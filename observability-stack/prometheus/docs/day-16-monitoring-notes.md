# Day 16: Prometheus Monitoring Implementation

## Objective

Implement Prometheus-based infrastructure and application monitoring for the DevOps Sample App deployed on Kubernetes.

## Architecture

Prometheus collects Kubernetes infrastructure metrics through kube-state-metrics, node-exporter, and kubelet/cAdvisor.

Application metrics are exposed through `/metrics` and discovered using ServiceMonitor or PodMonitor.

## Components Installed

| Component | Status |
|---|---|
| Prometheus | Installed |
| Prometheus Operator | Installed |
| kube-state-metrics | Installed |
| node-exporter | Installed |
| ServiceMonitor | Installed |
| PodMonitor | Installed |
| Application metrics endpoint | Updated with new image tag |

## PromQL Validation Results

| Metric | Actual result | Status |
|---|---|---|
| Container CPU | 0.0005064283255049338  | Validated |
| Container memory | 43.09765625 | Validated |
| Pod restarts | 0 | Validated |
| Unavailable replicas | 0 | Validated |
| HTTP 5xx error rate | 0 | Validated |
| p95 latency | 0.004749999999999999 | Validated |

## Production Challenge

Generate successful, failed, and slow requests to validate the application's metrics.

Record the number of requests generated, the PromQL result, and whether observed behavior matched expectations.

## Reliability Alignment

Proposed service reliability targets from Day 15:

- Availability SLO: 99.9%
- p95 latency SLO: under 300 ms
- Error rate SLO: below 1%

These targets are not considered achieved until representative measurement data is collected over the appropriate SLO windows.

## Limitations

- Prometheus currently uses lab-scale retention and storage.
- Monitoring is accessed locally via kubectl port-forward.
- The Flask demonstration uses a single Gunicorn worker for straightforward instrumentation.
- Availability SLO measurement requires a separately defined availability SLI and appropriate eligible request or probe data.
- Synthetic error and latency endpoints are for controlled testing only.
- Alert routing and Grafana dashboards are outside this day's scope.

## Next Steps

- Implement Grafana dashboards.
- Create Prometheus alerting rules.
- Add SLO and error-budget monitoring.
- Configure persistent metrics storage for longer retention.
- Improve production security and multi-worker metrics collection.