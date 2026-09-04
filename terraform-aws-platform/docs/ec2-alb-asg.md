# EC2 + ALB + Auto Scaling Group

## Architecture

```text
Internet
   ↓
Internet Gateway
   ↓
Application Load Balancer in public subnets
   ↓
Target Group
   ↓
EC2 instances in private subnets
   ↓
Outbound internet through NAT Gateway
```
## Components

| Component | Purpose |
|---|---|
| Launch Template | Defines EC2 configuration |
| Auto Scaling Group | Maintains desired number of instances |
| Application Load Balancer | Distributes public HTTP traffic |
| Target Group | Registers EC2 instances |
| Health Check | Validates instance health using `/health` |
| CloudWatch Alarms | Monitors CPU, unhealthy hosts, and response time |

## High Availability Design

- ALB is deployed across two public subnets.
- ASG launches EC2 instances across two private subnets.
- Desired capacity is set to 2.
- Failed instances are automatically replaced.
- ALB routes traffic only to healthy instances.