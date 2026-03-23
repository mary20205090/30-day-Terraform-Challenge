# Configure the provider with a variable-driven region so the cluster can be
# deployed in different AWS regions without changing the Terraform logic.
provider "aws" {
  region = var.region
}

# Reuse the default VPC to keep the lab focused on scaling concepts instead
# of custom VPC construction.
data "aws_vpc" "default" {
  default = true
}

# Query all subnets that belong to the default VPC. The load balancer and the
# Auto Scaling Group both use this list so instances can span subnets.
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# The lab explicitly asks for availability zones to be queried dynamically.
data "aws_availability_zones" "all" {}

# Look up the machine image dynamically so the launch template can reuse the
# same Terraform logic across regions and image versions.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  owners = [var.ami_owner]
}

# This security group protects the ALB. It accepts public HTTP traffic on the
# configured server port and allows the ALB to talk out to the instances.
resource "aws_security_group" "alb_sg" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Allow inbound HTTP traffic to the application load balancer"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP from configured CIDR blocks"
    from_port   = var.server_port
    to_port     = var.server_port
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
    Name        = "${var.cluster_name}-alb-sg"
    Environment = var.environment
    Terraform   = "true"
  }
}

# This security group protects the EC2 instances. Instead of allowing traffic
# from the whole internet, it only accepts traffic coming from the ALB.
resource "aws_security_group" "instance_sg" {
  name        = "${var.cluster_name}-instance-sg"
  description = "Allow ALB traffic to reach cluster instances"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description     = "Allow HTTP from the ALB"
    from_port       = var.server_port
    to_port         = var.server_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.cluster_name}-instance-sg"
    Environment = var.environment
    Terraform   = "true"
  }
}

# The Application Load Balancer is the public entry point. Users hit the ALB,
# and the ALB spreads requests across healthy EC2 instances in the cluster.
resource "aws_lb" "web_alb" {
  name               = "${var.cluster_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.default.ids

  tags = {
    Name        = "${var.cluster_name}-alb"
    Environment = var.environment
    Terraform   = "true"
  }
}

# The target group is the pool of EC2 instances behind the load balancer.
# The health check tells the ALB how to decide whether an instance is healthy.
resource "aws_lb_target_group" "web_tg" {
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
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }

  tags = {
    Name        = "${var.cluster_name}-tg"
    Environment = var.environment
    Terraform   = "true"
  }
}

# The listener binds the ALB port to the target group. In other words:
# traffic that reaches the ALB on var.server_port is forwarded to web_tg.
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = var.server_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# The launch template is the blueprint for each EC2 instance in the cluster.
# Every instance launched by the ASG uses this image, instance type, security
# group, and startup script.
resource "aws_launch_template" "web" {
  name_prefix   = "${var.cluster_name}-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # The startup script builds the same simple web page on every instance so
  # the ALB can distribute identical responses across the cluster.
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
                  <p>Region: ${var.region}</p>
                  <p>Served by an Auto Scaling Group behind an ALB.</p>
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

# The Auto Scaling Group keeps the cluster running across multiple instances.
# It uses the launch template above and registers instances with the target
# group so the ALB can send traffic to them.
resource "aws_autoscaling_group" "web" {
  name                = "${var.cluster_name}-asg"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
  # These subnets are where the ASG places instances. Using a subnet list
  # allows the cluster to spread across multiple availability zones.
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.web_tg.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.web.id
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

# Outputs give you the final ALB address to test in the browser after apply.
output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.web_alb.dns_name
}

output "alb_url" {
  description = "HTTP URL of the clustered web server"
  value       = "http://${aws_lb.web_alb.dns_name}:${var.server_port}"
}
