locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = "scalable-web-app"
  })
}

resource "aws_security_group" "instance" {
  name_prefix = "${var.name}-instance-${var.environment}-"
  description = "Allow HTTP from the ALB to EC2 instances."
  vpc_id      = var.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.name}-instance-sg-${var.environment}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_from_alb" {
  for_each = {
    for index, security_group_id in var.allowed_http_security_group_ids :
    tostring(index) => security_group_id
  }

  security_group_id            = aws_security_group.instance.id
  referenced_security_group_id = each.value
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.instance.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_launch_template" "web" {
  name_prefix   = "${var.name}-lt-${var.environment}-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = base64encode(<<-USERDATA
    #!/bin/bash
    set -euo pipefail

    dnf update -y
    dnf install -y httpd

    cat > /var/www/html/index.html <<'HTML'
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Day 26 Scalable Web App</title>
    </head>
    <body>
      <h1>Deployed with Terraform - Day 26</h1>
      <p>Environment: ${var.environment}</p>
      <p>Served by an Auto Scaling Group behind an Application Load Balancer.</p>
    </body>
    </html>
    HTML

    systemctl enable httpd
    systemctl start httpd
  USERDATA
  )

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${var.name}-${var.environment}"
    })
  }

  tag_specifications {
    resource_type = "volume"
    tags = merge(local.common_tags, {
      Name = "${var.name}-${var.environment}-root"
    })
  }

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}
