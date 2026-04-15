terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Day 21 runs in the default VPC so the lab stays focused on workflow safeguards.
data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ec2_instance_type_offerings" "supported" {
  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }

  location_type = "availability-zone"
}

locals {
  # Filter to AZs that support the chosen instance type to avoid placement failures.
  supported_azs = [
    for az in data.aws_availability_zones.available.names :
    az if contains(data.aws_ec2_instance_type_offerings.supported.locations, az)
  ]

  common_tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = var.project_name
    Owner       = var.team_name
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = local.supported_azs
  }
}

resource "random_id" "suffix" {
  byte_length = 3
}

module "webserver_cluster" {
  source = "../../modules/services/webserver-cluster"

  cluster_name               = "${var.cluster_name}-${random_id.suffix.hex}"
  environment                = var.environment
  project_name               = var.project_name
  team_name                  = var.team_name
  instance_type              = var.instance_type
  min_size                   = var.min_size
  max_size                   = var.max_size
  desired_capacity           = var.desired_capacity
  server_port                = var.server_port
  server_text                = var.server_text
  vpc_id                     = data.aws_vpc.default.id
  subnet_ids                 = data.aws_subnets.default.ids
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  enable_detailed_monitoring = var.enable_detailed_monitoring
}

resource "aws_cloudwatch_metric_alarm" "asg_capacity_low" {
  alarm_name          = "${var.cluster_name}-${random_id.suffix.hex}-asg-capacity-low"
  alarm_description   = "Alerts when the ASG has fewer in-service instances than expected."
  namespace           = "AWS/AutoScaling"
  metric_name         = "GroupInServiceInstances"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = 1
  threshold           = var.desired_capacity
  comparison_operator = "LessThanThreshold"
  treat_missing_data  = "breaching"
  alarm_actions       = [module.webserver_cluster.alerts_topic_arn]

  dimensions = {
    AutoScalingGroupName = module.webserver_cluster.asg_name
  }

  tags = merge(local.common_tags, {
    Name = "${var.cluster_name}-asg-capacity-low"
  })
}
