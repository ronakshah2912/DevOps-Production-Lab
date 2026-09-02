# Operational Runbook: ALB + Auto Scaling Group

## Purpose

This runbook provides operational steps to investigate and recover from EC2 instance failures behind an Application Load Balancer.

## Symptoms

- Application unavailable or partially unavailable
- ALB target group reports unhealthy targets
- CloudWatch alarm enters ALARM state
- ASG instance count below desired capacity
- HTTP 5xx errors increase

## Triage Steps

### 1. Check ALB endpoint

```bash
curl http://<ALB_DNS_NAME>
curl http://<ALB_DNS_NAME>/health
```

### 2. Check ASG health

```bash
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names <ASG_NAME> \
  --query "AutoScalingGroups[0].Instances[*].{InstanceId:InstanceId,LifecycleState:LifecycleState,HealthStatus:HealthStatus}" \
  --output table
```
### 3. Check target group health

```bash
aws elbv2 describe-target-health \
  --target-group-arn <TARGET_GROUP_ARN> \
  --query "TargetHealthDescriptions[*].{Instance:Target.Id,State:TargetHealth.State,Reason:TargetHealth.Reason}" \
  --output table
```
### 4. Check recent ASG scaling activity

```bash
aws autoscaling describe-scaling-activities \
  --auto-scaling-group-name <ASG_NAME> \
  --max-items 10 \
  --output table
```
### 5. Check CloudWatch alarm history

```bash
aws cloudwatch describe-alarm-history \
  --alarm-name <ALARM_NAME> \
  --max-items 10 \
  --output table
```

## Common Root Causes

| Issue | Possible Cause |
|---|---|
| Target unhealthy | Nginx not running, app not listening, bad health check path |
| Instance not launching | Launch template issue, AMI issue, subnet capacity issue |
| ALB cannot reach instance | Security group or NACL misconfiguration |
| Instance boots but fails health check | User data failure or application startup failure |
| No outbound internet | NAT Gateway or private route table issue |

## Recovery Actions

### If ASG does not replace instance

Check ASG events:

```bash
aws autoscaling describe-scaling-activities \
  --auto-scaling-group-name <ASG_NAME>
```
Review launch template and subnet configuration.

### If target is unhealthy

Check:

Security group allows ALB to EC2 on port 80
Health check path is /health
User data installed and started Nginx
EC2 instance is in private subnet
Route table and NAT Gateway are correct

### If traffic is failing

Check:

ALB listener exists on port 80
Target group has healthy targets
Security groups allow correct traffic
Application responds on /health

## Escalation

Escalate if:
- Replacement instance fails repeatedly
- All targets become unhealthy
- ALB returns 5xx errors for more than 10 minutes
- CloudWatch alarms remain in ALARM state
- Terraform configuration drift is suspected
Prevention
- Use health checks
- Use ASG desired capacity of at least 2
- Use multiple Availability Zones
- Use tested launch templates
- Use CloudWatch alarms
- Automate deployment validation
- Maintain rollback procedures