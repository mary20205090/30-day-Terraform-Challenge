locals {
  // Keep ALB resources tagged consistently with the rest of the stack.
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "scalable-web-app"
  })
}

resource "aws_security_group" "alb" {
  name_prefix = "${var.name}-alb-${var.environment}-"
  description = "Allow HTTP inbound to the ALB."
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.name}-alb-sg-${var.environment}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_lb" "web" {
  name               = "${var.name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids

  tags = merge(local.common_tags, {
    Name = "${var.name}-alb-${var.environment}"
  })
}

resource "aws_lb_target_group" "web" {
  // The ASG registers instances here; the ALB forwards only to healthy targets.
  name     = "${var.name}-tg-${var.environment}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = merge(local.common_tags, {
    Name = "${var.name}-tg-${var.environment}"
  })
}

resource "aws_lb_listener" "http" {
  // Public HTTP traffic enters here and is forwarded to the target group.
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_cloudwatch_metric_alarm" "high_request_count" {
  // Observability alarm only; CPU alarms in the ASG module perform scaling actions.
  alarm_name          = "${var.name}-high-requests-${var.environment}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "RequestCountPerTarget"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = var.high_request_threshold

  dimensions = {
    TargetGroup = aws_lb_target_group.web.arn_suffix
  }

  alarm_description  = "High request count per target. Review capacity if this alarm fires."
  treat_missing_data = "notBreaching"
  tags               = local.common_tags
}
