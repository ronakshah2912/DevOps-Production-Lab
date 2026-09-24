# Helm Deployment Notes

## Objective

Deploy the same application to dev and prod using a reusable Helm chart with environment-specific values.

## Chart Structure

```text
devops-sample-app/
├── Chart.yaml
├── values.yaml
├── values-dev.yaml
├── values-prod.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    └── ingress.yaml
```    

| Setting | Dev | Prod |
|---|---|---|
| Namespace | devops-lab-dev | devops-lab-prod |
| Release | devops-sample-app-dev | devops-sample-app-prod |
| Replicas | 1 | 3 |
| APP_ENV | dev | prod |
| LOG_LEVEL | DEBUG | INFO |
| Hostname | dev.devops-lab.local | prod.devops-lab.local |

## Commands

### Lint Chart

```bash
helm lint .
```

### Render Dev Manifest

```bash
helm template devops-sample-app-dev . -f values-dev.yaml
```

### Render Prod Manifest

```bash
helm template devops-sample-app-prod . -f values-prod.yaml
```

### Deploy Dev

```bash
helm upgrade --install devops-sample-app-dev . \
  -f values-dev.yaml \
  --namespace devops-lab-dev \
  --create-namespace
```

### Deploy Prod

```bash
helm upgrade --install devops-sample-app-prod . \
  -f values-prod.yaml \
  --namespace devops-lab-prod \
  --create-namespace
```

### Check Releases

```bash
helm list -n devops-lab-dev
helm list -n devops-lab-prod
```

### Rollback

```bash
helm history devops-sample-app-dev -n devops-lab-dev
helm rollback devops-sample-app-dev 1 -n devops-lab-dev
```

## Production Notes

- Dev and prod should use separate namespaces.
- Values files should control replicas, resources, environment variables, and ingress hosts.
- Secrets should be managed with external secret managers in real production.
- Helm releases should be deployed through CI/CD.
- Production deployments should require approval.
- Helm charts should be linted and rendered before deployment.