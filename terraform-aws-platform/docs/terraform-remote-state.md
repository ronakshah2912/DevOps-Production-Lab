# Terraform Remote State and Environment Separation

## Purpose

This project uses Amazon S3 as the Terraform remote backend with native S3 state locking enabled through `use_lockfile = true`.

## Backend Components

| Component | Purpose |
|---|---|
| S3 bucket | Stores Terraform state files |
| S3 native lockfile | Provides state locking during Terraform operations |
| S3 versioning | Allows recovery from accidental state overwrite |
| S3 encryption | Protects state at rest |
| S3 public access block | Prevents public exposure of Terraform state |

## No DynamoDB

DynamoDB-based Terraform state locking is not used in this project. The S3 backend uses native lockfile-based locking with:

```hcl
use_lockfile = true
```

## State File Structure

dev/vpc/terraform.tfstate
stage/vpc/terraform.tfstate
prod/vpc/terraform.tfstate

## Lock File Structure

dev/vpc/terraform.tfstate.tflock
stage/vpc/terraform.tfstate.tflock
prod/vpc/terraform.tfstate.tflock

## Environment Strategy

Dev
- Smaller CIDR: 10.10.0.0/20
- Public subnets: 10.10.1.0/24, 10.10.2.0/24
- Private subnets: 10.10.3.0/24, 10.10.4.0/24
- Used for low-cost testing and iteration
Stage
- Separate CIDR: 10.20.0.0/20
- Public subnets: 10.20.1.0/24, 10.20.2.0/24
- Private subnets: 10.20.3.0/24, 10.20.4.0/24
- Used for pre-production validation
Prod
- Larger CIDR: 10.30.0.0/16
- Public subnets: 10.30.1.0/24, 10.30.2.0/24
- Private subnets: 10.30.3.0/24, 10.30.4.0/24

## Security Controls

- S3 bucket encryption enabled
- S3 bucket versioning enabled
- S3 public access blocked
- Separate state keys per environment
- S3 lockfile state locking enabled
- Least-privilege IAM required for state and lock files
- Terraform state files are not committed to Git

## Commands

### Dev Env:

cd environments/dev
terraform init -reconfigure
terraform plan

### Stage Env:

cd environments/stage
terraform init -reconfigure
terraform plan

### Prod Env:

cd environments/prod
terraform init -reconfigure
terraform plan