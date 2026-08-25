# IAM Security Governance

## Purpose

This document explains the IAM governance and least-privilege approach used in the DevOps production lab.

## IAM Resources Created

| Resource | Purpose |
|---|---|
| EC2 instance role | Allows EC2 workloads to access approved AWS services without static credentials |
| EC2 instance profile | Attaches the IAM role to EC2 instances |
| Lambda execution role | Allows Lambda functions to run with controlled permissions |
| S3 read-only policy | Provides read-only access to approved S3 buckets |
| CloudWatch logging policy | Allows EC2 and Lambda workloads to write logs |
| Least-privilege Lambda S3 policy | Allows Lambda to read only a specific S3 prefix |

## Least-Privilege Design

The IAM policies avoid broad administrative access. Permissions are scoped by:

- Service
- Action
- Resource ARN
- S3 prefix where possible
- Role trust policy
- Environment tags

## Security Automation Checks

The Python audit script checks for:

- Public S3 buckets
- Security groups open to the internet
- IAM users with old access keys
- Unencrypted EBS volumes

## Governance Recommendations

- Prefer IAM roles over access keys
- Rotate or remove old access keys
- Avoid wildcard permissions where possible
- Use separate roles per workload
- Use CI/CD roles for Terraform deployment
- Enable CloudTrail for auditing
- Review IAM Access Analyzer findings
- Store secrets in AWS Secrets Manager or SSM Parameter Store
- Avoid committing credentials or state files to Git

## Resume Keywords

- IAM governance
- Least privilege
- Security automation
- Compliance checks
- Cloud security
- Access governance
- Infrastructure security
- AWS IAM