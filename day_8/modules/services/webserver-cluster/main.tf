# Reuse the default VPC so the module stays focused on packaging and reuse
# instead of creating custom networking from scratch.
data "aws_vpc" "default" {
  default = true
}

# Query all subnets in the default VPC so the load balancer and ASG can span
# more than one subnet.
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Look up a recent Ubuntu AMI instead of hardcoding an AMI ID.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  owners = [var.ami_owner]
}

# Keep repeated fixed values in locals so the module is easier to read and
# maintain without exposing every constant as an input variable.
locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

# Public-facing security group for the load balancer.
resource "aws_security_group" "alb" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Allow inbound HTTP traffic to the load balancer"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Public HTTP access to the ALB"
    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }

  tags = {
    Name        = "${var.cluster_name}-alb-sg"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Backend instance security group that only allows traffic from the ALB.
resource "aws_security_group" "instance" {
  name        = "${var.cluster_name}-instance-sg"
  description = "Allow HTTP traffic from the ALB"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "Application traffic from the ALB"
    from_port       = var.server_port
    to_port         = var.server_port
    protocol        = local.tcp_protocol
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }

  tags = {
    Name        = "${var.cluster_name}-instance-sg"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Load balancer target group for the EC2 instances in the cluster.
resource "aws_lb_target_group" "example" {
  name        = "${var.cluster_name}-tg"
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
    Name        = "${var.cluster_name}-tg"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Application Load Balancer used as the public entry point.
resource "aws_lb" "example" {
  name               = "${var.cluster_name}-alb"
  load_balancer_type = "application"
  internal           = false
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]

  tags = {
    Name        = "${var.cluster_name}-alb"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Listener that forwards incoming HTTP traffic to the target group.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = local.http_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

# Launch template defining the EC2 instances in the cluster.
resource "aws_launch_template" "example" {
  name_prefix   = "${var.cluster_name}-"
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
                  <title>${var.cluster_name}</title>
                </head>
                <body>
                  <h1>${var.cluster_name}</h1>
                  <p>Environment: ${var.environment}</p>
                  <p>Served through a reusable Terraform module.</p>
                </body>
              </html>
              HTML
              nohup python3 -m http.server ${var.server_port} --directory /var/www/html >/var/log/webserver.log 2>&1 &
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.cluster_name}-instance"
      Environment = var.environment
      Terraform   = "true"
    }
  }
}

# Auto Scaling Group that keeps the cluster running and attached to the ALB.
resource "aws_autoscaling_group" "example" {
  name                = "${var.cluster_name}-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.example.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
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
