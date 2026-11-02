| Metric | Prometheus metric name | Operational purpose |
|---|---|---|
| CPU | `container_cpu_usage_seconds_total` | Investigate CPU utilization |
| Memory | `container_memory_working_set_bytes` | Investigate memory pressure |
| Restarts | `kube_pod_container_status_restarts_total` | Identify unstable containers |
| Unavailable replicas | `kube_deployment_status_replicas_unavailable` | Identify reduced deployment capacity |
| HTTP 5xx | `http_requests_total` | Track failed application requests |
| p95 latency | `http_request_duration_seconds_bucket` | Measure user-facing response latency |

## Container CPU Usage

```promql
sum by (pod) (
  rate(container_cpu_usage_seconds_total{
    namespace="devops-lab-dev",
    container!="",
    container!="POD"
  }[5m])
)
```

## Container Memory Usage

```promql
sum by (pod) (
  container_memory_working_set_bytes{
    namespace="devops-lab-dev",
    container!="",
    container!="POD"
  }
) / 1024 / 1024
```

## Pod Restarts

```promql
sum by (pod) (
  kube_pod_container_status_restarts_total{
    namespace="devops-lab-dev"
  }
)
```

## Unavailable Deployment replicas

```promql
kube_deployment_status_replicas_unavailable{
  namespace="devops-lab-dev",
  deployment="devops-sample-app-dev-devops-sample-app"
}
```

## HTTP 5xx error queries

```promql
sum(
  rate(http_requests_total{
    namespace="devops-lab-dev",
    status=~"5.."
  }[5m])
)
```

## p95 request latency

```promql
histogram_quantile(
  0.95,
  sum by (le) (
    rate(http_request_duration_seconds_bucket{
      namespace="devops-lab-dev"
    }[5m])
  )
)
```
