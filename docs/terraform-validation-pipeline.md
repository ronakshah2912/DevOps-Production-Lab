# Terraform Validation Pipeline

## Purpose

This GitHub Actions workflow validates Terraform infrastructure code before deployment and requires manual approval before applying changes.

## Pipeline Stages

```text
terraform fmt
terraform init
terraform validate
tflint
checkov
terraform plan
manual approval
terraform apply
```

## Security Gates

The pipeline blocks deployment if:
- Terraform formatting fails
- Terraform validation fails
- TFLint detects linting issues
- Checkov detects security misconfigurations
- Security group allows SSH from 0.0.0.0/0
- S3 bucket public access block is disabled

## Manual Approval

Terraform apply is protected by a GitHub Environment called: dev-approval

The apply job only runs after approval.

## Production Best Practices

Use remote Terraform state in S3
Use S3 native lockfile with use_lockfile = true
Avoid committing .tfstate files
Review Terraform plan before apply
Require pull request reviews
Use least-privilege AWS credentials
Prefer GitHub OIDC over static access keys in production
Scan Terraform with Checkov
Scan Terraform quality with TFLin

Checkov already has built-in policies for risky security groups and public S3 configurations.

## Useful checks include:

```text
Security group should not allow unrestricted ingress to port 22
S3 bucket should block public access
S3 bucket should have encryption enabled
S3 bucket should have versioning enabled
```
Pipeline blocks because:

```text
soft_fail: false
```
This means security failures stop the pipeline.