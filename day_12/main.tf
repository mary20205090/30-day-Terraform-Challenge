provider "aws" {
  region = var.region
}

provider "random" {}

# Use the default VPC and its subnets so the lab stays focused on deployment behavior.
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  owners = [var.ami_owner]
}

# Security groups for the ALB and the EC2 instances behind it.
resource "aws_security_group" "alb" {
  name_prefix = "${var.cluster_name}-alb-"
  description = "ALB security group for Day 12 demos"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "instance" {
  name_prefix = "${var.cluster_name}-instance-"
  description = "Instance security group for Day 12 demos"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port       = var.server_port
    to_port         = var.server_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# One ALB is shared by both the rolling and blue/green deployment demos.
resource "aws_lb" "demo" {
  name_prefix        = "d12-"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.default.ids
}

# Rolling deployment target group used on port 80.
resource "aws_lb_target_group" "rolling" {
  name_prefix = "rol-"
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
    matcher             = "200"
  }
}

# Separate target groups let us switch traffic atomically between blue and green.
resource "aws_lb_target_group" "blue" {
  name_prefix = "blu-"
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
    matcher             = "200"
  }
}

resource "aws_lb_target_group" "green" {
  name_prefix = "grn-"
  port        = var.server_port
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 15
    timeout             = 5
    matcher             = "200"
  }
}

resource "aws_lb_listener" "rolling" {
  load_balancer_arn = aws_lb.demo.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.rolling.arn
  }
}

# Port 8080 is reserved for the blue/green demo so it doesn't interfere with rolling updates.
resource "aws_lb_listener" "blue_green" {
  load_balancer_arn = aws_lb.demo.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No active blue/green rule"
      status_code  = "200"
    }
  }
}

# Changing this one listener rule flips all traffic between blue and green in a single update.
resource "aws_lb_listener_rule" "blue_green" {
  listener_arn = aws_lb_listener.blue_green.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = var.active_environment == "blue" ? aws_lb_target_group.blue.arn : aws_lb_target_group.green.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

# A new ID is generated when the app version changes so Terraform can keep old and new ASGs side by side.
resource "random_id" "rolling" {
  keepers = {
    app_version = var.app_version
  }

  byte_length = 4
}

# Rolling deployment resources: create the new template and ASG first, then remove the old ones.
resource "aws_launch_template" "rolling" {
  name_prefix   = "${var.cluster_name}-${random_id.rolling.hex}-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  user_data = base64encode(templatefile("${path.module}/user-data.sh.tftpl", {
    server_port   = var.server_port
    response_text = "Hello World ${var.app_version}"
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instance.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "rolling" {
  name_prefix         = "${var.cluster_name}-${random_id.rolling.hex}-"
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.rolling.arn]
  health_check_type   = "ELB"
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity

  launch_template {
    id      = aws_launch_template.rolling.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-${var.app_version}"
    propagate_at_launch = true
  }
}

# Blue environment resources stay deployed even when they are not actively serving traffic.
resource "aws_launch_template" "blue" {
  name_prefix   = "${var.cluster_name}-blue-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  user_data = base64encode(templatefile("${path.module}/user-data.sh.tftpl", {
    server_port   = var.server_port
    response_text = "Blue environment ${var.blue_version}"
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instance.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Green environment resources stay deployed too, so traffic can switch instantly at the listener.
resource "aws_launch_template" "green" {
  name_prefix   = "${var.cluster_name}-green-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  user_data = base64encode(templatefile("${path.module}/user-data.sh.tftpl", {
    server_port   = var.server_port
    response_text = "Green environment ${var.green_version}"
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.instance.id]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "blue" {
  name_prefix         = "${var.cluster_name}-blue-"
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.blue.arn]
  health_check_type   = "ELB"
  min_size            = var.blue_green_min_size
  max_size            = var.blue_green_max_size
  desired_capacity    = var.blue_green_desired_capacity

  launch_template {
    id      = aws_launch_template.blue.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "green" {
  name_prefix         = "${var.cluster_name}-green-"
  vpc_zone_identifier = data.aws_subnets.default.ids
  target_group_arns   = [aws_lb_target_group.green.arn]
  health_check_type   = "ELB"
  min_size            = var.blue_green_min_size
  max_size            = var.blue_green_max_size
  desired_capacity    = var.blue_green_desired_capacity

  launch_template {
    id      = aws_launch_template.green.id
    version = "$Latest"
  }

  lifecycle {
    create_before_destroy = true
  }
}
