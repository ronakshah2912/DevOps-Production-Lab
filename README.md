# DevOps-Production-Lab
<<<<<<< HEAD
This is demo repository for learning purpose. This repository contains code base for each DevOps skill such as Terraform, CI/CD, Observability, Automation, EKS, Kubernetes with following DevOps best practices
=======
This repository documents a production-style DevOps lab that demonstrates infrastructure automation, Kubernetes operations, CI/CD, observability, incident response, and safe AI-assisted operational workflows.

>>>>>>> 186ea27 (Initial Terraform infrastructure code)
## Architecture Goal

This repository is designed to simulate a production-grade DevOps environment using AWS, Terraform, Kubernetes, CI/CD, observability, automation, and incident response practices.

The goal is to build hands-on projects that demonstrate real-world DevOps engineering skills including infrastructure provisioning, Kubernetes platform operations, deployment automation, monitoring, alerting, troubleshooting, and production support.

## Tools Used

- AWS CLI
    ```text
    aws --version
- Terraform
    ```text
    terraform version
- Docker
    ```text
    docker --version
- Kubernetes
- kubectl
    ```text
    kubectl version
- Helm
    ```text
    helm version
- GitHub Actions
- Python
    ```text
    python -V
- Bash / PowerShell
- Prometheus
- Grafana
- CloudWatch
- Git
    ```text
    git --version

## Repository Structure
```text
devops-production-lab/
├── terraform-aws-platform/
├── eks-platform/
├── cicd-pipelines/
├── observability-stack/
├── automation-scripts/
└── incident-runbooks/
```

## Environment Assumptions

    AWS region: ca-central-1
    Infrastructure will be deployed using Terraform
    Kubernetes workloads will be tested locally first and later deployed to EKS
    CI/CD workflows will be built using GitHub Actions
    Monitoring will use CloudWatch, Prometheus, and Grafana
    Automation scripts will use Python, Bash, or PowerShell

## Cost-Control Notes

To avoid unnecessary cloud costs:

    Use small instance types where possible
    Destroy test infrastructure after use
    Avoid leaving NAT Gateways, load balancers, and EKS clusters running unnecessarily
    Use Terraform destroy after testing
    Track AWS billing alerts and budgets
    Prefer local testing before deploying to AWS

## Security Assumptions

Security practices followed in this lab:

    Use least-privilege IAM policies
    Avoid hardcoding credentials
    Use environment variables or AWS profiles
    Restrict security group access
    Avoid public S3 buckets
    Encryption is required for supported storage and state resources.
    Document security risks and remediation steps
    Scan Terraform and container images before deployment

## Projects

1. Terraform AWS Platform

Production-style AWS infrastructure using Terraform modules.

2. EKS Platform

Kubernetes platform using EKS, Helm, and GitOps patterns.

3. CI/CD Pipelines

Automated validation, build, deployment, and rollback workflows.

4. Observability Stack

Monitoring, logging, dashboards, alerting, and SRE practices.

5. Automation Scripts

Python, Bash, and PowerShell scripts for operational automation.

6. Incident Runbooks

Production-style troubleshooting, incident response, RCA, and disaster recovery documentation.

## Day 4: IAM, Security, and Compliance Automation

Completed security-focused DevOps automation work including:

- EC2 instance IAM role
- Lambda execution IAM role
- S3 read-only least-privilege policy
- CloudWatch logging policy
- Python-based AWS security audit script
- Public S3 bucket detection
- Security group exposure detection
- IAM access key age detection
- Unencrypted EBS volume detection

Project keywords:

```text
IAM governance, least privilege, security automation, compliance checks, AWS IAM, CloudWatch logging, S3 read-only access, IAM roles, access governance