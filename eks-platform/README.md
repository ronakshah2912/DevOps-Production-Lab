# Day 8: Docker Production Standards

## Objective

Containerize a sample application using Docker production best practices.

## Application

The sample app is a Python Flask API with:

- `/` application endpoint
- `/health` health check endpoint
- `/ready` readiness endpoint

## Docker Features Implemented

- Multi-stage build
- Slim runtime image
- Non-root user
- Health check
- Environment variables
- Gunicorn production server
- `.dockerignore`
- No pip cache

## Image Size Comparison

| Image | Size Before/After | Notes |
|---|---:|---|
| `devops-sample-app:basic` | 1.62 GB | Basic Python image, root user, no optimization |
| `devops-sample-app:prod` | 200 MB | Multi-stage, slim image, non-root user |
| `devops-sample-app:alpine` | 110 MB | Optional smaller Alpine image |

## Security Scanning

Scans were performed using:

- Docker Scout
- Trivy
- Grype

## Security Findings Summary

| Tool | Critical | High | Medium | Notes |
|---|---:|---:|---:|---|
| Docker Scout | 5 | 10 | 11 | Low:30 |
| Trivy | 3 | 54 | 61 | Low:58 |

## Remediation Steps

Document the actual remediation steps based on scan results:

- Update base image regularly.
- Pin dependencies in `requirements.txt`.
- Rebuild image frequently to include patched packages.
- Use non-root users.
- Avoid unnecessary OS packages.
- Remove build tools from runtime image.
- Use `.dockerignore` to reduce build context.
- Scan images before deployment.
- Fail CI/CD pipeline on critical vulnerabilities.

## Commands Used

```bash
docker build -f Dockerfile.basic -t devops-sample-app:basic .
docker build -t devops-sample-app:prod .
docker images devops-sample-app
docker run --rm -p 8080:8080 devops-sample-app:prod
docker scout cves devops-sample-app:prod
trivy image devops-sample-app:prod
grype devops-sample-app:prod
```

## Production Notes

In a production environment, this image should be:
- Built by CI/CD
- Scanned before pushing to registry
- Pushed to Amazon ECR or another approved registry
- Deployed to Kubernetes or ECS
- Monitored using logs, metrics, and health checks



# Day 9: Kubernetes Deployment Fundamentals with Production Patterns

## Objective

Deploy a production-style Kubernetes application using manifests for Namespace, Deployment, Service, ConfigMap, Secret, resource requests and limits, readiness probe, and liveness probe.

## Components Created

| Resource | Purpose |
|---|---|
| Namespace | Isolates lab resources |
| ConfigMap | Stores non-sensitive application configuration |
| Secret | Stores sensitive configuration |
| Deployment | Manages application replicas and rolling updates |
| Service | Provides stable internal networking |
| Readiness Probe | Controls when pod receives traffic |
| Liveness Probe | Restarts unhealthy containers |
| Resource Requests | Helps Kubernetes schedule pods |
| Resource Limits | Prevents resource overuse |

## Apply Manifests

```bash
kubectl apply -f manifests/
```

## Validate

```bash
kubectl get all -n devops-lab
kubectl get configmap,secret -n devops-lab
kubectl describe deployment devops-sample-app -n devops-lab
```

## Test App

```bash
kubectl port-forward svc/devops-sample-app-service 8080:80 -n devops-lab
curl http://localhost:8080/
curl http://localhost:8080/health
curl http://localhost:8080/ready
```

## Production Troubleshooting Scenarios

This lab covers:

- CrashLoopBackOff
- ImagePullBackOff
- ConfigMap error
- Probe 

## Key Troubleshooting Commands

```bash
kubectl logs
kubectl describe pod
kubectl get events
kubectl exec
```

## Production Notes

In production, these manifests should be enhanced with:
- Ingress or Gateway API
- Horizontal Pod Autoscaler
- PodDisruptionBudget
- NetworkPolicy
- External Secrets or AWS Secrets Manager integration
- CI/CD deployment workflow
- Image scanning
- Kubernetes RBAC