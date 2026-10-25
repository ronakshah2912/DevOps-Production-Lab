# Day 13: GitOps with Argo CD

## Objective

Install Argo CD on EKS and implement GitOps-based application deployment using Git as the source of truth.

## Components

| Component | Purpose |
|---|---|
| Argo CD | GitOps continuous delivery controller |
| Application Manifest | Defines Git repo path, target cluster, namespace, and sync policy |
| Git Deployment Folder | Stores desired Kubernetes manifests |
| Auto-Sync Policy | Automatically applies Git changes to dev |
| Manual Approval Process | Uses PR review and manual sync for prod |
| Rollback Process | Reverts Git commit or uses Argo CD rollback |

## GitOps Flow

```text
Developer changes manifest in Git
        ↓
Pull request review
        ↓
Merge to main
        ↓
Argo CD detects Git change
        ↓
Argo CD compares desired vs live state
        ↓
Sync applies change to Kubernetes
        ↓
App returns Healthy / Synced
```

## Dev Sync Policy
Dev uses automated sync:

```YAML
syncPolicy:
  automated:
    prune: true
    selfHeal: true
  syncOptions:
    - CreateNamespace=true
```

## Prod Sync Policy
Prod uses manual sync:

```YAML
syncPolicy:
  syncOptions:
    - CreateNamespace=true
```

## Drift Test
Manual drift introduced:

```bash
kubectl scale deployment devops-sample-app -n devops-lab-gitops-dev --replicas=5
```

## Expected result:
Argo CD detects drift and self-heals the deployment back to the Git-defined replica count.

## Image Tag Change Test
Changed image from:

devops-sample-app:1.0.0

to:

devops-sample-app:1.0.1

## Expected result:
Argo CD detects OutOfSync, applies the new image tag, and returns the application to Synced / Healthy.

## Rollback Method
Preferred rollback:

```bash
git revert <commit-id>
git push origin main
```
Then Argo CD syncs the previous desired state.

## Validation Commands

```bash
argocd app list
argocd app get devops-sample-app-dev
argocd app history devops-sample-app-dev
kubectl get all -n devops-lab-gitops-dev
kubectl rollout status deployment/devops-sample-app -n devops-lab-gitops-dev
kubectl logs -n devops-lab-gitops-dev -l app=devops-sample-app
```

## Production Notes
- Git should be the source of truth.
- Dev can use auto-sync.
- Prod should require PR approval and manual sync.
- Rollbacks should be committed back to Git.
- Secrets should not be stored as plain YAML.
- Argo CD RBAC should restrict production sync permissions.