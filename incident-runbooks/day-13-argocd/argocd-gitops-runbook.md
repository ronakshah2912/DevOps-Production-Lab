# Argo CD GitOps Runbook

## Check Argo CD Health

```bash
kubectl get pods -n argocd
kubectl get svc -n argocd
kubectl logs -n argocd deployment/argocd-server
kubectl logs -n argocd statefulset/argocd-application-controller
```
## Access Argo CD UI

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
URL:
```text
https://localhost:8080
```

## Get Initial Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

## Check Application

```bash
argocd app list
argocd app get devops-sample-app-dev
kubectl get application devops-sample-app-dev -n argocd
```

## Force Refresh

```bash
argocd app refresh devops-sample-app-dev
```

## Manual Sync

```bash
argocd app sync devops-sample-app-dev
```

## Check Kubernetes Resources

```bash
kubectl get all -n devops-lab-gitops-dev
kubectl describe deployment devops-sample-app -n devops-lab-gitops-dev
kubectl logs -n devops-lab-gitops-dev -l app=devops-sample-app
```

## Drift Troubleshooting

```bash
kubectl scale deployment devops-sample-app -n devops-lab-gitops-dev --replicas=5
argocd app get devops-sample-app-dev
```

Expected:
```text
Argo CD self-heals the deployment back to Git state.
```

## ArgoCD Application Health check failed Troubleshooting
ArgoCD application synced successfully but having issue with health status and health was degraded.

### Troubleshooting steps:

```bash
kubectl describe application devops-sample-app-dev -n argocd
argocd app get devops-sample-app-dev
kubectl get deployment -n devops-lab-gitops-dev
```
Output:
    NAME                READY   UP-TO-DATE   AVAILABLE   AGE
    devops-sample-app   0/2     2            0           22m
    
```bash
kubectl get pods -n devops-lab-gitops-dev
```
Output:
    Events:
  Type     Reason            Age                From               Message
  ----     ------            ----               ----               -------
  Warning  FailedScheduling  26m                default-scheduler  0/1 nodes are available: 1 Too many pods. no new claims to deallocate, preemption: 0/1 nodes are available: 1 No preemption victims found for incoming pod.
  Warning  FailedScheduling  15m (x2 over 20m)  default-scheduler  0/1 nodes are available: 1 Too many pods. no new claims to deallocate, preemption: 0/1 nodes are available: 1 No preemption victims found for incoming pod.

- Above error clearly showed that EKS cluster currently only has 1 worker node, and that node has already reached its maximum pod capacity (the Max Pods limit enforced by AWS).
We can spin up new worker nodes to resolve this error. But since this EKS cluster deployed through Terraform, configuration drift should manager properly with Production grade approach.

### Resolution:
1. Update Terraform configuration code manually.

```text
    eks_node_desired_size = 2
    eks_node_min_size     = 1
    eks_node_max_size     = 3
    eks_node_disk_size    = 20
```

```bash
terraform plan -out=tfplan
terraform apply tfplan
```
2. Dynamic scaling by by adding ignore_change to Terraform manifest. This allows tools to change node count on the fly without Terraform trying to override them on next deployment.

```text
lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size, # Prevents TF from rolling back auto-scaled nodes
    ]
  }
```

## Rollback
Preferred GitOps rollback:

```bash
git log --oneline
git revert <commit-id>
git push origin main
argocd app refresh devops-sample-app-dev
```

## Argo CD rollback option:

```bash
argocd app history devops-sample-app-dev
argocd app rollback devops-sample-app-dev <history-id>
```

## Common Issues
Issue	Cause	Fix
Application OutOfSync	Git and live state differ	Review diff and sync
Application Degraded	Pods failing or service unhealthy	Check pods, events, logs
Repo not accessible	Private repo or wrong URL	Configure repo credentials
ImagePullBackOff	Wrong image tag or ECR issue	Check ECR image and node IAM
Sync fails	Invalid YAML or RBAC issue	Check Argo CD app events


## Step 24: Final validation commands

Run:

```bash
kubectl get pods -n argocd
kubectl get applications -n argocd
argocd app list
argocd app get devops-sample-app-dev
kubectl get all -n devops-lab-gitops-dev
kubectl get deployment devops-sample-app -n devops-lab-gitops-dev -o wide
kubectl get pods -n devops-lab-gitops-dev -o wide
kubectl logs -n devops-lab-gitops-dev -l app=devops-sample-app
```

## Validate image tag:

```bash
kubectl get deployment devops-sample-app \
  -n devops-lab-gitops-dev \
  -o jsonpath='{.spec.template.spec.containers[0].image}'; echo
```

## Validate app endpoint:

```bash
kubectl port-forward svc/devops-sample-app 8080:80 -n devops-lab-gitops-dev
```

In another terminal:

```bash
curl http://localhost:8080/health
curl http://localhost:8080/ready
```