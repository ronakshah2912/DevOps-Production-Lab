#!/bin/bash

REGION="ca-central-1"

echo "Checking security groups open to 0.0.0.0/0..."
aws ec2 describe-security-groups \
  --region "$REGION" \
  --query "SecurityGroups[?IpPermissions[?IpRanges[?CidrIp=='0.0.0.0/0']]].{GroupId:GroupId,GroupName:GroupName,VpcId:VpcId}" \
  --output table

echo "Checking unencrypted EBS volumes..."
aws ec2 describe-volumes \
  --region "$REGION" \
  --query "Volumes[?Encrypted==\`false\`].{VolumeId:VolumeId,State:State,Size:Size,AZ:AvailabilityZone}" \
  --output table

echo "Checking IAM users and access keys..."
for user in $(aws iam list-users --query "Users[].UserName" --output text); do
  echo "User: $user"
  aws iam list-access-keys \
    --user-name "$user" \
    --query "AccessKeyMetadata[].{AccessKeyId:AccessKeyId,Status:Status,CreateDate:CreateDate}" \
    --output table
done

echo "Checking S3 public access block configuration..."
for bucket in $(aws s3api list-buckets --query "Buckets[].Name" --output text); do
  echo "Bucket: $bucket"
  aws s3api get-public-access-block \
    --bucket "$bucket" \
    --query "PublicAccessBlockConfiguration" \
    --output table 2>/dev/null || echo "No public access block configuration found"
done