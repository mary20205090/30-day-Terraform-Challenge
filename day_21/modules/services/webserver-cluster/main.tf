terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

locals {
  # Keep tag defaults in one place so the composed modules stay consistent.
  common_tags = merge(
    {
      Environment = var.environment
      ManagedBy   = "terraform"
      Project     = var.project_name
      Owner       = var.team_name
    },
    var.custom_tags
  )
}

module "alb" {
  source = "../../networking/alb"

  alb_name            = "${var.cluster_name}-alb"
  environment         = var.environment
  project_name        = var.project_name
  team_name           = var.team_name
  vpc_id              = var.vpc_id
  subnet_ids          = var.subnet_ids
  allowed_cidr_blocks = var.allowed_cidr_blocks
}

resource "aws_lb_target_group" "app" {
  name_prefix = substr("${var.cluster_name}-", 0, 6)
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  # Keep the health check simple and fast so the ALB can detect bad instances quickly.
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-tg"
  })
}

module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  cluster_name          = "${var.cluster_name}-asg"
  environment           = var.environment
  project_name          = var.project_name
  team_name             = var.team_name
  instance_type         = var.instance_type
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  server_port           = var.server_port
  vpc_id                = var.vpc_id
  subnet_ids            = var.subnet_ids
  target_group_arns     = [aws_lb_target_group.app.arn]
  health_check_type     = "ELB"
  alb_security_group_id = module.alb.alb_security_group_id
  user_data = templatefile("${path.module}/user-data.sh.tftpl", {
    server_port = var.server_port
    server_text = var.server_text
  })
  enable_detailed_monitoring = var.enable_detailed_monitoring
  custom_tags                = var.custom_tags
}

resource "aws_lb_listener_rule" "app" {
  # Route all HTTP paths from the shared listener to this cluster's target group.
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}
