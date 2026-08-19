# Terraform AWS Platform

This project creates a production-style AWS network foundation using Terraform modules.

## Components

- VPC
- Public subnets across 2 Availability Zones
- Private subnets across 2 Availability Zones
- Internet Gateway
- NAT Gateway
- Public and private route tables
- Least-privilege security groups
- S3 Gateway VPC Endpoint
- CloudWatch Logs Interface VPC Endpoint

## Design Goals

- High availability across 2 Availability Zones
- Public/private subnet separation
- Private workloads with outbound internet through NAT Gateway
- Least-privilege network access
- Reusable Terraform module structure
- Production-style documentation

## Folder Structure

```text
terraform-aws-platform/
├── modules/
│   └── vpc/
├── environments/
│   └── dev/
└── docs/
```