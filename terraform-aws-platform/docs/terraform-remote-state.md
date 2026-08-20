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