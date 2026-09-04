output "alb_dns_name" {
  description = "Application Load balancer DNS name"
  value       = aws_lb.app.dns_name
}

output "alb_arn" {
  description = "Application Load Balancer ARN."
  value       = aws_lb.app.arn
}

output "target_group_arn" {
  description = "ALB Target Group ARN."
  value       = aws_lb_target_group.app.arn
}

output "target_group_name" {
  description = "ALB Target Group name."
  value       = aws_lb_target_group.app.name
}

output "launch_template_id" {
  description = "Launch Template ID."
  value       = aws_launch_template.app.id
}

output "autoscaling_group_name" {
  description = "Auto Scaling Group name."
  value       = aws_autoscaling_group.app.name
}

output "high_cpu_alarm_name" {
  description = "CloudWatch Alarm name for high CPU usage."
  value       = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}

output "unhealthy_hosts_alarm_name" {
  description = "CloudWatch Alarm name for unhealthy hosts."
  value       = aws_cloudwatch_metric_alarm.unhealthy_hosts.alarm_name
}

output "target_response_time_alarm_name" {
  description = "CloudWatch Alarm name for high target response time."
  value       = aws_cloudwatch_metric_alarm.target_response_time.alarm_name
}