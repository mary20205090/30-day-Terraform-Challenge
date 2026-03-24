# Day 5 focuses on two connected ideas:
# 1. Terraform state as the record of what Terraform manages
# 2. A load-balanced web app where the ALB becomes the public entry point

# Use a variable-driven region so the same configuration can be reused
# across environments without rewriting the Terraform logic.
provider "aws" {
  region = var.region
}

# Reuse the default VPC and its subnets so this exercise stays focused on
# ALB/ASG behavior and Terraform state instead of custom networking.
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Query availability zones dynamically, as required by the assignment.
data "aws_availability_zones" "all" {}

# Look up a recent Ubuntu image instead of hardcoding an AMI ID.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  owners = [var.ami_owner]
}

# The ALB security group is public-facing. It accepts inbound HTTP from
# allowed CIDR blocks and can send traffic to the backend instances.
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Allow inbound HTTP traffic to the load balancer"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Public HTTP access to the ALB"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-alb-sg"
    Environment = var.environment
    Terraform   = "true"
  }
}

# The instance security group is intentionally restricted. The EC2 instances
# do not accept traffic from the internet directly; only the ALB can reach
# them on the application port.
resource "aws_security_group" "instance" {
  name        = "${var.project_name}-instance-sg"
  description = "Allow HTTP only from the ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = var.server_port
    to_port         = var.server_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-instance-sg"
    Environment = var.environment
    Terraform   = "true"
  }
}

# The launch template is the blueprint for every EC2 instance in the ASG.
# Each instance serves the same page so the load balancer can distribute
# requests across the fleet.
resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = base64encode(<<-EOF
              #!/bin/bash
              set -e
              apt-get update -y
              apt-get install -y python3
              mkdir -p /var/www/html
              cat > /var/www/html/index.html <<HTML
              <!DOCTYPE html>
              <html>
                <head>
                  <title>${var.project_name}</title>
                </head>
                <body>
                  <h1>${var.project_name}</h1>
                  <p>Environment: ${var.environment}</p>
                  <p>Region: ${var.region}</p>
                  <p>Served through an ALB by an Auto Scaling Group.</p>
                </body>
              </html>
              HTML
              nohup python3 -m http.server ${var.server_port} --directory /var/www/html >/var/log/webserver.log 2>&1 &
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.project_name}-instance"
      Environment = var.environment
      Terraform   = "true"
    }
  }
}

# The target group tracks healthy EC2 instances. The ALB will only send
# traffic to instances that pass the HTTP health check.
resource "aws_lb_target_group" "web" {
  name        = "${var.project_name}-tg"
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    matcher             = "200"
    interval            = 15
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.project_name}-tg"
    Environment = var.environment
    Terraform   = "true"
  }
}

# The Application Load Balancer is the single public entry point for users.
resource "aws_lb" "example" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  internal           = false
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Public-facing listener on port 80, as required by the task.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# The Auto Scaling Group keeps the desired number of instances running and
# attaches those instances to the target group so the ALB can reach them.
resource "aws_autoscaling_group" "example" {
  name                = "${var.project_name}-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.web.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}

output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "alb_url" {
  value       = "http://${aws_lb.example.dns_name}"
  description = "Browser URL for the load balancer"
}
