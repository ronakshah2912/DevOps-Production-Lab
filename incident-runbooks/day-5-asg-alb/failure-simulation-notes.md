# Failure Simulation Notes: EC2 + ALB + Auto Scaling Group

## Scenario

One EC2 instance in the Auto Scaling Group was manually terminated to simulate an unexpected production instance failure.

## Environment

- AWS Region: ca-central-1
- Environment: dev
- ASG desired capacity: 2
- ASG minimum size: 2
- ASG maximum size: 4
- ALB health check path: `/health`
- Application port: 80

## Commands Used

```bash
INSTANCE_ID=$(aws autoscaling describe-auto-scaling-groups \
  --auto-scaling-group-names <ASG_NAME> \
  --query "AutoScalingGroups[0].Instances[0].InstanceId" \
  --output text)

aws ec2 terminate-instances --instance-ids $INSTANCE_ID
```

## Expected Behavior
- EC2 instance is terminated.
- Auto Scaling Group detects capacity below desired count.
- ASG launches a replacement instance.
- ALB marks old target as unhealthy or draining.
- ALB routes traffic only to healthy targets.
- Replacement instance passes health checks.
- Desired capacity returns to normal.