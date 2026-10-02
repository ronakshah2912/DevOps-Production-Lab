# Day 12: Kubernetes Networking and Ingress

## Objective

Install and configure AWS Load Balancer Controller, create an ALB-backed Kubernetes Ingress, and document TLS and ExternalDNS concepts.

## Components

| Component | Purpose |
|---|---|
| AWS Load Balancer Controller | Provisions AWS ALB/NLB resources from Kubernetes resources |
| Ingress | Defines HTTP routing rules |
| Service | Routes traffic to application pods |
| ALB | Public entry point for HTTP/HTTPS traffic |


## Traffic Flow

```text
User
  ↓
DNS / Host header (/)
  ↓
AWS ALB
  ↓
Ingress rule
  ↓
Kubernetes Service
  ↓
Service endpoint
  ↓
Ready pod
```

## AWS Load Balancer Controller Validation

```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-load-balancer-controller
kubectl logs -n kube-system deployment/aws-load-balancer-controller
```

## Ingress Validation

```bash
kubectl get ingress -n devops-lab-eks
kubectl describe ingress devops-sample-app-ingress -n devops-lab-eks
```

## Test With Host Header

```bash
ALB_HOST=$(kubectl get ingress devops-sample-app-ingress -n devops-lab-eks -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
```
- Go to browser and type http://<$ALB_HOST>/health

## Production Troubleshooting Scenarios

- Ingress not routing
- Service selector mismatch
- Pod not receiving traffic

## Final validation commands

```bash
kubectl get nodes
kubectl get pods -n kube-system
kubectl get deployment -n kube-system aws-load-balancer-controller
kubectl get pods -n devops-lab-eks -o wide
kubectl get svc -n devops-lab-eks
kubectl get endpoints -n devops-lab-eks
kubectl get ingress -n devops-lab-eks
kubectl describe ingress devops-sample-app-ingress -n devops-lab-eks
```

## Test application:

http://<$ALB_HOST>/
http://<$ALB_HOST>/health
http://<$ALB_HOST>/ready