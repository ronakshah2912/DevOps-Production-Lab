# Day 11: EKS Provisioning with Terraform

## Objective

Provision an Amazon EKS platform using Terraform and deploy the sample application to validate cluster functionality.

## Components Created

| Component | Purpose |
|---|---|
| EKS Cluster | Managed Kubernetes control plane |
| Managed Node Group | Worker nodes for application pods |
| EKS Cluster IAM Role | Allows EKS to manage AWS resources |
| EKS Node IAM Role | Allows worker nodes to join cluster and pull images |
| Cluster Security Group | Controls EKS control plane network communication |
| Node Security Group | Controls worker node communication |
| OIDC Provider | Enables IAM roles for Kubernetes service accounts |
| ECR Repository | Stores container image for EKS deployment |
| Helm Release | Deploys application to EKS |

## Terraform Module

```text
terraform-aws-platform/modules/eks/
├── main.tf
├── variables.tf
├── outputs.tf
└── versions.tf
```

## Environment

terraform-aws-platform/environments/dev/

## Deployment Flow

```text
Terraform apply
   ↓
Create EKS cluster
   ↓
Create managed node group
   ↓
Update kubeconfig
   ↓
Push app image to ECR
   ↓
Deploy app with Helm
   ↓
Validate pods, service, logs, and nodes
```

## Validation Commands

```bash
kubectl get nodes -o wide
kubectl get pods -A
kubectl get pods -n devops-lab-eks -o wide
kubectl get svc -n devops-lab-eks
kubectl logs -n devops-lab-eks -l app.kubernetes.io/instance=devops-sample-app-eks
```

## Service Test

```bash
curl http://<LOAD_BALANCER_HOSTNAME>/
curl http://<LOAD_BALANCER_HOSTNAME>/health
curl http://<LOAD_BALANCER_HOSTNAME>/ready
```

## Production Notes

- Use private subnets for worker nodes.
- Use managed node groups for operational simplicity.
- Enable OIDC provider for future IRSA integration.
- Use ECR for container image storage.
- Use Helm for repeatable application deployment.
- Enable cluster logs for audit and troubleshooting.
- Use least-privilege IAM roles.
- Destroy lab resources when testing is complete to control cost.