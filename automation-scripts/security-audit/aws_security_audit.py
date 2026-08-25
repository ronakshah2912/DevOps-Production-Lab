import boto3
import csv
from datetime import datetime, timezone, timedelta
from botocore.exceptions import ClientError


REGION = "ca-central-1"
OLD_ACCESS_KEY_DAYS = 90
REPORT_FILE = "aws_security_audit_report.csv"


def write_finding(findings, check_name, resource_id, severity, finding, recommendation):
    findings.append({
        "timestamp": datetime.now(timezone.utc).isoformat(),
        "check_name": check_name,
        "resource_id": resource_id,
        "severity": severity,
        "finding": finding,
        "recommendation": recommendation
    })


def check_public_s3_buckets(findings):
    s3 = boto3.client("s3")

    try:
        buckets = s3.list_buckets().get("Buckets", [])
    except ClientError as e:
        write_finding(
            findings,
            "Public S3 Buckets",
            "s3",
            "High",
            f"Unable to list S3 buckets: {e}",
            "Verify IAM permissions for s3:ListAllMyBuckets."
        )
        return

    for bucket in buckets:
        bucket_name = bucket["Name"]
        is_public = False
        reasons = []

        try:
            pab = s3.get_public_access_block(Bucket=bucket_name)
            config = pab.get("PublicAccessBlockConfiguration", {})
            if not all([
                config.get("BlockPublicAcls", False),
                config.get("IgnorePublicAcls", False),
                config.get("BlockPublicPolicy", False),
                config.get("RestrictPublicBuckets", False)
            ]):
                is_public = True
                reasons.append("Public access block is not fully enabled")
        except ClientError:
            is_public = True
            reasons.append("Public access block is not configured")

        try:
            acl = s3.get_bucket_acl(Bucket=bucket_name)
            for grant in acl.get("Grants", []):
                grantee = grant.get("Grantee", {})
                uri = grantee.get("URI", "")
                if "AllUsers" in uri or "AuthenticatedUsers" in uri:
                    is_public = True
                    reasons.append("Bucket ACL grants public or authenticated-user access")
        except ClientError:
            reasons.append("Could not evaluate bucket ACL")

        if is_public:
            write_finding(
                findings,
                "Public S3 Buckets",
                bucket_name,
                "High",
                "; ".join(reasons),
                "Enable S3 Block Public Access and remove public ACLs or public bucket policies."
            )


def check_open_security_groups(findings):
    ec2 = boto3.client("ec2", region_name=REGION)

    try:
        security_groups = ec2.describe_security_groups().get("SecurityGroups", [])
    except ClientError as e:
        write_finding(
            findings,
            "Open Security Groups",
            "ec2-security-groups",
            "High",
            f"Unable to describe security groups: {e}",
            "Verify IAM permissions for ec2:DescribeSecurityGroups."
        )
        return

    risky_ports = {
        22: "SSH",
        3389: "RDP",
        3306: "MySQL",
        5432: "PostgreSQL",
        1433: "SQL Server",
        6379: "Redis",
        9200: "Elasticsearch"
    }

    for sg in security_groups:
        group_id = sg.get("GroupId")
        group_name = sg.get("GroupName")

        for permission in sg.get("IpPermissions", []):
            from_port = permission.get("FromPort")
            to_port = permission.get("ToPort")
            protocol = permission.get("IpProtocol")

            for ip_range in permission.get("IpRanges", []):
                cidr = ip_range.get("CidrIp")

                if cidr == "0.0.0.0/0":
                    if protocol == "-1":
                        severity = "Critical"
                        finding = "All traffic is open to the internet"
                    elif from_port in risky_ports:
                        severity = "Critical"
                        finding = f"{risky_ports[from_port]} port {from_port} is open to the internet"
                    elif from_port in [80, 443]:
                        severity = "Medium"
                        finding = f"Web port {from_port} is open to the internet"
                    else:
                        severity = "High"
                        finding = f"Port range {from_port}-{to_port} is open to the internet"

                    write_finding(
                        findings,
                        "Security Groups Open to Internet",
                        f"{group_id} ({group_name})",
                        severity,
                        finding,
                        "Restrict inbound access to approved CIDR ranges or trusted security groups."
                    )


def check_old_iam_access_keys(findings):
    iam = boto3.client("iam")
    cutoff = datetime.now(timezone.utc) - timedelta(days=OLD_ACCESS_KEY_DAYS)

    try:
        users = iam.list_users().get("Users", [])
    except ClientError as e:
        write_finding(
            findings,
            "Old IAM Access Keys",
            "iam-users",
            "High",
            f"Unable to list IAM users: {e}",
            "Verify IAM permissions for iam:ListUsers."
        )
        return

    for user in users:
        username = user["UserName"]

        try:
            keys = iam.list_access_keys(UserName=username).get("AccessKeyMetadata", [])
        except ClientError:
            continue

        for key in keys:
            access_key_id = key["AccessKeyId"]
            created = key["CreateDate"]

            if created < cutoff:
                age_days = (datetime.now(timezone.utc) - created).days

                write_finding(
                    findings,
                    "Old IAM Access Keys",
                    f"{username}/{access_key_id}",
                    "High",
                    f"Access key is {age_days} days old",
                    "Rotate or delete old access keys. Prefer IAM roles over long-lived access keys."
                )


def check_unencrypted_ebs_volumes(findings):
    ec2 = boto3.client("ec2", region_name=REGION)

    try:
        volumes = ec2.describe_volumes().get("Volumes", [])
    except ClientError as e:
        write_finding(
            findings,
            "Unencrypted EBS Volumes",
            "ebs-volumes",
            "High",
            f"Unable to describe EBS volumes: {e}",
            "Verify IAM permissions for ec2:DescribeVolumes."
        )
        return

    for volume in volumes:
        volume_id = volume["VolumeId"]
        encrypted = volume.get("Encrypted", False)
        state = volume.get("State", "unknown")
        size = volume.get("Size", "unknown")

        if not encrypted:
            write_finding(
                findings,
                "Unencrypted EBS Volumes",
                volume_id,
                "High",
                f"EBS volume is not encrypted. State={state}, Size={size}GiB",
                "Enable EBS encryption by default and migrate data to encrypted volumes."
            )


def save_report(findings):
    fieldnames = [
        "timestamp",
        "check_name",
        "resource_id",
        "severity",
        "finding",
        "recommendation"
    ]

    with open(REPORT_FILE, mode="w", newline="", encoding="utf-8") as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(findings)

    print(f"Security audit completed. Findings: {len(findings)}")
    print(f"Report saved to: {REPORT_FILE}")


def main():
    findings = []

    check_public_s3_buckets(findings)
    check_open_security_groups(findings)
    check_old_iam_access_keys(findings)
    check_unencrypted_ebs_volumes(findings)

    save_report(findings)


if __name__ == "__main__":
    main()