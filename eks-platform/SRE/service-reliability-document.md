# Service Reliability Document

## Service Name

DevOps Sample App

## Service Description

The DevOps Sample App is a containerized Python web application deployed on Kubernetes. It exposes HTTP endpoints for application traffic, health checks, and readiness checks.

## Service Endpoints

| Endpoint | Purpose |
|---|---|
| `/` | Main application endpoint |
| `/health` | Liveness and health check endpoint |
| `/ready` | Readiness check endpoint |

## Deployment Platform

| Component | Value |
|---|---|
| Container Runtime | Docker |
| Orchestration | Kubernetes |
| Deployment Method | Kubernetes manifests / Helm / GitOps |
| Cloud Platform | AWS / EKS or local Kubernetes lab |
| Observability | Kubernetes logs, metrics, future Prometheus/Grafana |

### Why this step matters:
Before defining reliability targets, you need to clearly define what service you are measuring. SRE work becomes confusing if the service boundary is unclear. This section explains what the app does, where it runs, and which endpoints matter.

## Define SLI: Service Level Indicator

A Service Level Indicator, or SLI, is a measurable signal that shows how well the service is performing from the user’s perspective.

For this application, the main SLIs are:

| SLI | Description | Measurement |
|---|---|---|
| Availability | Percentage of successful requests | Successful HTTP responses divided by total HTTP requests |
| Latency | Time taken to respond to user requests | p95 response time |
| Error Rate | Percentage of failed requests | 5xx responses divided by total requests |
| Readiness | Whether the app is ready to receive traffic | `/ready` endpoint returns HTTP 200 |
| Health | Whether the app is alive and functioning | `/health` endpoint returns HTTP 200 |

### Why this step matters:
An SLI is the actual metric. Without SLIs, reliability is just an opinion. SLIs let you say, “The service is healthy because availability is 99.95%,” instead of “It seems fine.”

For your app, the best starter SLIs are:
```text
availability
latency
error rate
readiness
health
```

## Define SLO: Service Level Objectives

A Service Level Objective, or SLO, is the target reliability level for a service.

For this application, the proposed SLOs are:

| Category | SLO Target | Reason |
|---|---:|---|
| Availability | 99.9% monthly availability | Suitable for a production-style web service |
| Latency | p95 response time under 300ms | Keeps user-facing responses fast |
| Error Rate | Less than 1% 5xx errors | Keeps failed requests within an acceptable limit |
| Readiness | 99.9% of readiness checks return HTTP 200 | Ensures only healthy pods receive traffic |
| Health | 99.9% of health checks return HTTP 200 | Ensures failed containers are restarted quickly |

### Why this step matters:
An SLO defines the goal. For example:
```text
Availability SLO: 99.9%
Latency SLO: p95 under 300ms
Error Rate SLO: below 1%
```
This gives your team a clear reliability target. If the app falls below the target, it means reliability work should become a priority.

## Define SLA: Service Level Agreement

A Service Level Agreement, or SLA, is an external commitment made to customers or business stakeholders.

For this lab project, there is no formal customer-facing SLA. However, a sample SLA could be:

| SLA Category | Commitment |
|---|---|
| Availability | 99.5% monthly availability |
| Support Response | Critical incidents acknowledged within 30 minutes |
| Communication | Major service disruption updates provided every 60 minutes |

## Difference Between SLO and SLA

| Term | Meaning |
|---|---|
| SLO | Internal reliability target used by engineering teams |
| SLA | External reliability commitment made to customers or stakeholders |

The SLA is usually lower than the SLO to provide operational safety margin.

### Why this step matters:
SLO and SLA are often confused. The SLO is your internal engineering goal. The SLA is the external promise. For your portfolio, it is good to show that you understand the difference.
### Example:
```text
SLO: 99.9%
SLA: 99.5%
```
This means the engineering team aims higher than what is promised externally.

## Error Budget

An error budget is the amount of allowed unreliability within a specific time period.

If the availability SLO is 99.9%, then the allowed monthly error budget is 0.1%.

## Monthly Error Budget Calculation

Assuming a 30-day month:

```text
30 days x 24 hours = 720 hours
720 hours x 60 minutes = 43,200 minutes
0.1% error budget = 43.2 minutes
```

## Error Budget Policy
| Error Budget Remaining | Action |
|---:|---|
| 100% to 50% remaining | Normal feature delivery can continue |
| 50% to 25% remaining | Review reliability risks before major releases |
| 25% to 0% remaining | Freeze risky deployments and prioritize reliability |
| 0% remaining | Stop non-critical releases until reliability improves |

### Why this step matters:
An error budget helps balance **feature delivery** and **reliability**.

If your service has a 99.9% SLO, it can be unavailable for about:
```text
43.2 minutes per 30-day month
```
If the service uses up that budget, the team should slow down risky deployments and focus on stability.

## Define Incident Severity Levels

Incident severity defines how serious a production issue is and how quickly the team should respond.

| Severity | Description | Example | Target Response |
|---|---|---|---|
| SEV1 | Critical outage affecting most or all users | App unavailable, service returns 5xx for all traffic | Immediate response |
| SEV2 | Major degradation affecting many users | High error rate, severe latency, partial outage | Response within 30 minutes |
| SEV3 | Minor degradation or limited user impact | One pod failing, intermittent errors, non-critical feature issue | Response within 4 business hours |
| SEV4 | Low-impact issue or improvement item | Documentation issue, non-urgent alert tuning | Response within next planning cycle |

# Why this step matters:
Severity levels prevent confusion during incidents. Instead of debating how serious an issue is, the team can classify it quickly and respond appropriately.
### Example:
```text
All pods down = SEV1
One pod restarting but service still works = SEV3
```

## Define Reliability Alert Examples

| Alert | Condition | Severity |
|---|---|---|
| High Error Rate | 5xx error rate above 1% for 5 minutes | SEV2 |
| Service Down | Availability below 99% over 5 minutes | SEV1 |
| High Latency | p95 latency above 300ms for 10 minutes | SEV2 |
| Pod CrashLooping | Pod restarts more than 3 times in 10 minutes | SEV3 |
| No Ready Pods | Deployment has zero ready replicas | SEV1 |
| Ingress Not Routing | ALB or Ingress cannot route traffic to service | SEV2 |

### Why this step matters:
SLOs are only useful if you know when to act. Alerts connect reliability targets to operational response.
### Example:
```text
SLO says p95 latency should stay under 300ms.
Alert fires if p95 latency is over 300ms for 10 minutes.
```

## Define Incident Response Workflow

```text
Alert triggered
     ↓
Engineer acknowledges incident
     ↓
Severity level assigned
     ↓
Initial investigation begins
     ↓
Customer or stakeholder impact assessed
     ↓
Mitigation applied
     ↓
Service health validated
     ↓
Incident resolved
     ↓
Post-incident review completed
```

## Incident Response Commands

```bash
kubectl get pods -n <namespace>
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>
kubectl get events -n <namespace> --sort-by=.metadata.creationTimestamp
kubectl get deployment -n <namespace>
kubectl rollout status deployment/<deployment-name> -n <namespace>
kubectl rollout undo deployment/<deployment-name> -n <namespace>
```

### Why this step matters:
During an incident, engineers should not waste time figuring out what to do next. A response workflow gives a repeatable process for triage, mitigation, and recovery.

## Rollback Criteria

A rollback should be considered when:

| Condition | Action |
|---|---|
| New deployment causes high 5xx error rate | Roll back to previous stable version |
| New deployment causes p95 latency above SLO | Roll back or scale resources |
| New deployment causes pods to crash | Roll back immediately |
| Health or readiness probes fail after deployment | Roll back after quick investigation |
| Error budget is nearly exhausted | Avoid risky releases and prioritize stability |

## Rollback Commands

```bash
kubectl rollout history deployment/devops-sample-app -n <namespace>
kubectl rollout undo deployment/devops-sample-app -n <namespace>
kubectl rollout status deployment/devops-sample-app -n <namespace>
```
### For GitOps-based rollback:
```bash
git revert <commit-id>
git push origin main
```

### Why this step matters:
Rollback criteria help engineers make quick decisions. If a release causes reliability issues, the safest action may be to restore the previous working version instead of debugging live production for too long.

## Define Post-Incident Review Template

### Incident Summary

Describe what happened.

### Customer Impact

Describe who was affected and how.

### Timeline

| Time | Event |
|---|---|
| HH:MM | Alert triggered |
| HH:MM | Engineer acknowledged |
| HH:MM | Root cause identified |
| HH:MM | Mitigation applied |
| HH:MM | Service restored |

### Root Cause

Explain the technical cause of the incident.

### What Went Well

List what helped during the incident.

### What Could Be Improved

List process, tooling, monitoring, or automation gaps.

### Action Items

| Action Item | Owner | Due Date |
|---|---|---|
| Add missing alert | Platform team | TBD |
| Improve readiness probe | DevOps team | TBD |
| Update runbook | SRE team | TBD |

### Why this step matters:
The goal of SRE is not just to fix incidents. It is to learn from them. A post-incident review helps prevent repeat failures and improves the system over time.

## Production Reliability Summary

This service reliability document defines how the DevOps Sample App should be measured, monitored, and supported in a production-style environment.

The service reliability model includes:

- SLIs for availability, latency, error rate, readiness, and health
- SLOs for 99.9% availability, p95 latency under 300ms, and error rate below 1%
- Sample SLA commitments
- Monthly error budget calculation
- Incident severity levels
- Reliability alert examples
- Rollback criteria
- Post-incident review process

This document can be used by DevOps, SRE, platform, and application teams to align on reliability expectations and incident response.

### Why this step matters:
This final summary clearly explains what your Day 15 deliverable achieved. It makes the document useful for portfolio review, interviews, and future project days when you add observability tools.