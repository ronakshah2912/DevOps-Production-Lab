# Kubernetes Troubleshooting Notes

## Namespace

```bash
kubectl get namespaces
kubectl get all -n devops-lab
```

## Logs

```bash
kubectl logs -n devops-lab -l app=devops-sample-app
kubectl logs <pod-name> -n devops-lab
kubectl logs <pod-name> -n devops-lab --previous
```

## Describe Pod

```bash
kubectl describe pod <pod-name> -n devops-lab
```

Use this to investigate:
- Container state
- Restart count
- Image pull issues
- Missing ConfigMaps or Secrets
- Failed readiness or liveness probes
- Events attached to the pod

## Events

```bash
kubectl get events -n devops-lab --sort-by=.metadata.creationTimestamp
```

## Exec Into Pod

```bash
kubectl exec -it <pod-name> -n devops-lab -- sh
```

### Useful checks inside pod:

```bash
whoami
env
ls -la
python -c "import urllib.request; print(urllib.request.urlopen('http://localhost:8080/health').read())"
```

## CrashLoopBackOff

Common Causes
- Application exits immediately
- Bad command or entrypoint
- Missing runtime dependency
- App cannot start because configuration is invalid
Commands
```bash
kubectl logs <pod-name> -n devops-lab
kubectl logs <pod-name> -n devops-lab --previous
kubectl describe pod <pod-name> -n devops-lab
kubectl get events -n devops-lab --sort-by=.metadata.creationTimestamp
```

## ImagePullBackOff

Common Causes
- Wrong image name
- Wrong image tag
- Private registry authentication issue
- Local image not loaded into Kind or Minikube
Commands
```bash
kubectl describe pod <pod-name> -n devops-lab
kubectl get events -n devops-lab --sort-by=.metadata.creationTimestamp
```

## ConfigMap Error

Common Causes
- ConfigMap name mismatch
- ConfigMap missing in the namespace
- Deployment references wrong ConfigMap
Commands
```bash
kubectl get configmap -n devops-lab
kubectl describe pod <pod-name> -n devops-lab
```

## Probe Failure

Common Causes
- Wrong readiness path
- Wrong liveness path
- Application startup takes longer than probe delay
- App listens on a different port
Commands
```bash
kubectl describe pod <pod-name> -n devops-lab
kubectl logs <pod-name> -n devops-lab
kubectl get events -n devops-lab --sort-by=.metadata.creationTimestamp
```