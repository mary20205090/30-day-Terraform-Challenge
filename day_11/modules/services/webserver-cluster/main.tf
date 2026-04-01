locals {
  is_production = var.environment == "production"

  # Centralize all conditional choices here so the resource blocks stay readable.
  instance_type               = local.is_production ? "t3.small" : "t3.micro"
  min_cluster_size            = local.is_production ? 3 : 1
  max_cluster_size            = local.is_production ? 10 : 3
  detailed_monitoring_enabled = var.enable_detailed_monitoring != null ? var.enable_detailed_monitoring : local.is_production
  dns_record_enabled          = var.create_dns_record != null ? var.create_dns_record : local.is_production
  common_tags = {
    Name        = var.cluster_name
    Environment = var.environment
    Terraform   = "true"
  }
}

data "aws_vpc" "default" {
  count   = var.use_existing_vpc ? 1 : 0
  default = true
}

resource "aws_vpc" "new" {
  count      = var.use_existing_vpc ? 0 : 1
  cidr_block = "10.20.0.0/16"

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-vpc"
  })
}

data "aws_subnets" "default" {
  count = var.use_existing_vpc ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default[0].id]
  }
}

resource "aws_subnet" "new" {
  count                   = var.use_existing_vpc ? 0 : 1
  vpc_id                  = aws_vpc.new[0].id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-subnet"
  })
}

locals {
  vpc_id    = var.use_existing_vpc ? data.aws_vpc.default[0].id : aws_vpc.new[0].id
  subnet_id = var.use_existing_vpc ? data.aws_subnets.default[0].ids[0] : aws_subnet.new[0].id
}

resource "aws_security_group" "web" {
  name        = "${var.cluster_name}-sg"
  description = "Security group for the Day 11 webserver"
  vpc_id      = local.vpc_id

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ssh_dev" {
  count             = local.is_production ? 0 : 1
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  owners = [var.ami_owner]
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = local.instance_type
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  monitoring                  = local.detailed_monitoring_enabled

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-instance"
  })
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  count = local.detailed_monitoring_enabled ? 1 : 0

  alarm_name          = "${var.cluster_name}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU utilization exceeded 80%"

  dimensions = {
    InstanceId = aws_instance.web.id
  }
}

data "aws_route53_zone" "primary" {
  count        = local.dns_record_enabled ? 1 : 0
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "web" {
  count   = local.dns_record_enabled ? 1 : 0
  zone_id = data.aws_route53_zone.primary[0].zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = 300
  records = [aws_instance.web.public_ip]
}
