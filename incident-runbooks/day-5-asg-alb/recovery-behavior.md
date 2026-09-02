# Recovery Behavior: EC2 + ALB + ASG

## Recovery Flow

```text
Instance failure
   ↓
EC2 instance enters shutting-down / terminated state
   ↓
Auto Scaling Group detects capacity below desired count
   ↓
ASG launches replacement instance from Launch Template
   ↓
Instance boots and runs user data
   ↓
Nginx starts and exposes /health endpoint
   ↓
ALB health check validates target
   ↓
Target becomes healthy
   ↓
Traffic resumes through ALB
```

## Key Recovery Components

| Component | Recovery Role |
|---|---|
| Launch Template | Defines AMI, instance type, security groups, IAM profile, and user data |
| Auto Scaling Group | Maintains desired capacity and replaces failed instances |
| Target Group | Tracks registered EC2 targets |
| ALB Health Check | Determines whether an instance should receive traffic |
| CloudWatch Alarm | Detects unhealthy targets, high CPU, or slow response time |
| User Data | Bootstraps application during instance launch |

## Recovery Validation

```bash
aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names <ASG_NAME>
```

```bash
aws elbv2 describe-target-health \
  --target-group-arn <TARGET_GROUP_ARN>
```

```bash
curl http://<ALB_DNS_NAME>/health
```

## Success Criteria

- ASG desired capacity is restored.
- Replacement instance is InService.
- ALB target state is healthy.
- Application endpoint returns successful response.
- CloudWatch alarm returns to OK.