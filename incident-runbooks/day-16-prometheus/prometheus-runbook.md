## Troubleshoot common Prometheus issues

| Problem | Likely cause | What to check |
|---|---|---|
| Target missing | Monitor label mismatch | ServiceMonitor labels and Prometheus selectors |
| Target DOWN | `/metrics` unreachable | Service port, Pod health, network policy |
| CPU metrics missing | kubelet/cAdvisor scraping issue | Prometheus target health |
| Node metrics missing | node-exporter not running | DaemonSet status |
| Deployment metrics missing | kube-state-metrics not scraped | Exporter pods and targets |
| 5xx metrics missing | Application not instrumented or no errors observed | `/metrics` endpoint and generated traffic |
| p95 returns no data | Histogram absent or insufficient samples | Histogram buckets and request traffic |
| Metrics counted twice | ServiceMonitor and PodMonitor scraping same target | Remove duplicate monitor |

## Standard Checks For:

```bash
# Monitoring platform health
kubectl get pods -n monitoring

# Service discovery
kubectl get servicemonitor,podmonitor -A

# Application health
kubectl get pods -n devops-lab-dev

# Application logs
kubectl logs -n devops-lab-dev -l app.kubernetes.io/instance=devops-sample-app-dev

# Prometheus UI
kubectl port-forward svc/monitoring-kube-prometheus-prometheus 9090:9090 -n monitoring
```

## Final Validation

```bash
kubectl get pods -n monitoring

kubectl get servicemonitor,podmonitor -A

kubectl describe servicemonitor devops-sample-app -n devops-lab-dev

kubectl get svc -n devops-lab-dev --show-labels

kubectl get pods -n devops-lab-dev --show-labels

kubectl logs -n devops-lab-dev -l app.kubernetes.io/instance=devops-sample-app-dev

kubectl get events -n monitoring --sort-by=.metadata.creationTimestamp
```