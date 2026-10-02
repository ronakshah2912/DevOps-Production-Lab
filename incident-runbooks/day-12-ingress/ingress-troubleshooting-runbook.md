# Day 12: Ingress Troubleshooting Runbook

## Objective

Troubleshoot Kubernetes Ingress traffic flow on Amazon EKS using AWS Load Balancer Controller.

## Traffic Flow

```text
Client
  ↓
root directory path (/) for health checks (No DNS Record)
  ↓
AWS ALB
  ↓
Ingress rule
  ↓
Kubernetes Service
  ↓
Service Endpoints
  ↓
Ready 
```

## Core Commands

```bash
kubectl get ingress -n devops-lab-eks
kubectl describe ingress devops-sample-app-ingress -n devops-lab-eks
kubectl get svc -n devops-lab-eks
kubectl describe svc devops-sample-app-eks-devops-sample-app -n devops-lab-eks
kubectl get endpoints -n devops-lab-eks
kubectl get pods -n devops-lab-eks -o wide
kubectl describe pod <pod-name> -n devops-lab-eks
kubectl logs -n kube-system deployment/aws-load-balancer-controller
kubectl get events -n devops-lab-eks --sort-by=.metadata.creationTimestamp
```

## Ingress Not Routing

### Possible Causes

- Wrong backend service name
- Wrong service port
- Missing IngressClass
- AWS Load Balancer Controller not running
- Subnet tags missing
- ALB target group unhealthy

### Commands

```bash
kubectl describe ingress devops-sample-app-ingress -n devops-lab-eks
kubectl logs -n kube-system deployment/aws-load-balancer-controller
kubectl get ingressclass
kubectl get svc -n devops-lab-eks
```

## Service Selector Mismatch

### Symptom

Service has no endpoints.

### Commands

```bash
kubectl get svc devops-sample-app-eks-devops-sample-app -n devops-lab-eks -o yaml
kubectl get pods -n devops-lab-eks --show-labels
kubectl get endpoints devops-sample-app-eks-devops-sample-app -n devops-lab-eks
```

### Fix

Ensure service selector matches pod labels.

## Pod Not Receiving Traffic

### Possible Causes

- Pod not Ready
- Readiness probe failing
- Service has no endpoints
- Health check path mismatch
- Target group unhealthy

### Commands

```bash
kubectl get pods -n devops-lab-eks
kubectl describe pod <pod-name> -n devops-lab-eks
kubectl logs <pod-name> -n devops-lab-eks
kubectl get endpoints -n devops-lab-eks
```

## Host Header Test

- Go to browser and type http://<load balancer dns name>