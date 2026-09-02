locals {
  name_prefix = "${var.project_name}-${var.environment}"

  tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_lb" "app" {
    name               = "${local.name_prefix}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.alb_security_group_id]
    subnets            = var.public_subnet_ids
    
    enable_deletion_protection = false
    
    tags = merge(
        local.tags,
        {
            Name = "${local.name_prefix}-alb"
        }
    )
}

resource "aws_lb_target_group" "app" {
    name     = "${local.name_prefix}-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    target_type = "instance"

    health_check {
        enabled             = true
        path                = "/health"
        protocol            = "HTTP"
        interval            = 30
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
    }

    tags = merge(
        local.tags,
        {
            Name = "${local.name_prefix}-tg"
        }
    )
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.app.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.app.arn
    }
}

resource "aws_launch_template" "app" {
    name_prefix   = "${local.name_prefix}-lt-"
    image_id      = data.aws_ami.latest_amazon_linux.id
    instance_type = var.instance_type
    
    iam_instance_profile {
        name = var.ec2_instance_profile_name
    }

    vpc_security_group_ids = [var.app_security_group_id]

    user_data = base64encode(file("${path.module}/user_data.sh"))

    metadata_options {
        http_tokens = "required"
        http_endpoint = "enabled"
        http_put_response_hop_limit = 2
    }

    monitoring {
        enabled = true
    }

    tag_specifications {
        resource_type = "instance"
        tags = merge(
            local.tags,
            {
                Name = "${local.name_prefix}-app-instance"
                role = "private-application-server"
            }
        )
    }

    tag_specifications {
        resource_type = "volume"
        tags = merge(
            local.tags,
            {
                Name = "${local.name_prefix}-app-volume"
            }
        )
    }

    lifecycle {
        create_before_destroy = true
    }
  
}

resource "aws_autoscaling_group" "app" {
    name                      = "${local.name_prefix}-asg"
    max_size                  = var.max_size
    min_size                  = var.min_size
    desired_capacity          = var.desired_capacity
    vpc_zone_identifier       = var.private_subnet_ids
    launch_template {
        id      = aws_launch_template.app.id
        version = "$Latest"
    }
    
    target_group_arns         = [aws_lb_target_group.app.arn]

    health_check_type         = "ELB"
    health_check_grace_period = 300

    tag {
        key                 = "Name"
        value               = "${local.name_prefix}-asg-instance"
        propagate_at_launch = true
    }

    tag {
        key                 = "Project"
        value               = var.project_name
        propagate_at_launch = true
    }

    tag {
        key                 = "Environment"
        value               = var.environment
        propagate_at_launch = true
    }

    tag {
        key                 = "ManagedBy"
        value               = "Terraform"
        propagate_at_launch = true
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
    alarm_name          = "${local.name_prefix}-asg-high-cpu"
    alarm_description   = "Triggers when average ASG CPU utilization is greater than 70 percent."
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 2
    metric_name         = "CPUUtilization"
    namespace           = "AWS/EC2"
    period              = 60
    statistic           = "Average"
    threshold           = 70

    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.app.name
    }
    treat_missing_data = "notBreaching"
    tags = merge(
        local.tags,
        {
            Name = "${local.name_prefix}-asg-high-cpu"
        }
    )
}

resource "aws_cloudwatch_metric_alarm" "unhealthy_hosts" {
    alarm_name          = "${local.name_prefix}-asg-unhealthy-hosts"
    alarm_description   = "Triggers when ALB target group has one or more unhealthy hosts."
    comparison_operator = "GreaterThanThreshold"
    evaluation_periods  = 1
    metric_name         = "UnhealthyHostCount"
    namespace           = "AWS/ApplicationELB"
    period              = 60
    statistic           = "Average"
    threshold           = 1

    dimensions = {
        LoadBalancerName = aws_lb.app.arn_suffix
        TargetGroup       = aws_lb_target_group.app.arn_suffix
    }
    treat_missing_data = "notBreaching"
    tags = merge(
        local.tags,
        {
            Name = "${local.name_prefix}-alb-unhealthy-hosts"
        }
    )
  
}

resource "aws_cloudwatch_metric_alarm" "target_response_time" {
  alarm_name          = "${local.name_prefix}-alb-high-response-time"
  alarm_description   = "Triggers when ALB target response time is high."
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    TargetGroup  = aws_lb_target_group.app.arn_suffix
    LoadBalancer = aws_lb.app.arn_suffix
  }

  treat_missing_data = "notBreaching"

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-alb-high-response-time"
  })
}