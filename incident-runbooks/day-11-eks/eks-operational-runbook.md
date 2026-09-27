## Purpose

This runbook provides commands to validate and troubleshoot an EKS cluster and application deployment.

## Check Cluster Access

```bash
aws eks update-kubeconfig --region ca-central-1 --name <CLUSTER_NAME>
kubectl cluster-info
kubectl get nodes
```

## Check Node Health

```bash
kubectl get nodes -o wide
kubectl describe node <NODE_NAME>
```

## Check System Pods

```bash
kubectl get pods -n kube-system
kubectl logs -n kube-system -l k8s-app=aws-node
kubectl logs -n kube-system -l k8s-app=kube-dns
```

## Check Application Pods

```bash
kubectl get pods -n devops-lab-eks -o wide
kubectl describe pod <POD_NAME> -n devops-lab-eks
kubectl logs <POD_NAME> -n devops-lab-eks
```

## Check Service

```bash
kubectl get svc -n devops-lab-eks
kubectl describe svc devops-sample-app-eks-devops-sample-app -n devops-lab-eks
```

## Common Issues

| Issue | Possible Cause | Troubleshooting |
|---|---|---|
| Nodes not Ready | IAM role, CNI, subnet, security group issue | Check node group status and kube-system pods |
| Pods Pending | Not enough CPU/memory or node issue | `kubectl describe pod` |
| ImagePullBackOff | ECR image missing or node role lacks ECR access | Check image URI and node IAM role |
| Service not reachable | LoadBalancer provisioning delay or SG issue | Check service events and AWS Load Balancer |
| Logs not visible | Pod not running or wrong selector | Check pod name and labels |

## Recovery Commands

```bash
kubectl rollout restart deployment/devops-sample-app-eks-devops-sample-app -n devops-lab-eks
kubectl rollout status deployment/devops-sample-app-eks-devops-sample-app -n devops-lab-eks
helm rollback devops-sample-app-eks 1 -n devops-lab-eks
```