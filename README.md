# DevOps-Production-Lab
This is demo repository for learning purpose. This repository contains code base for each DevOps skill such as Terraform, CI/CD, Observability, Automation, EKS, Kubernetes with following DevOps best practices
## Architecture Goal

This repository is designed to simulate a production-grade DevOps environment using AWS, Terraform, Kubernetes, CI/CD, observability, automation, and incident response practices.

The goal is to build hands-on projects that demonstrate real-world DevOps engineering skills including infrastructure provisioning, Kubernetes platform operations, deployment automation, monitoring, alerting, troubleshooting, and production support.

## Tools Used

- AWS CLI
    ```text
    $ aws --version

- Terraform
- Docker
- Kubernetes
- kubectl
- Helm
- GitHub Actions
- Python
- Bash / PowerShell
- Prometheus
- Grafana
- CloudWatch
- Git

## Repository Structure

devops-production-lab/
├── terraform-aws-platform/
├── eks-platform/
├── cicd-pipelines/
├── observability-stack/
├── automation-scripts/
└── incident-runbooks/

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
    Enable encryption where possible
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