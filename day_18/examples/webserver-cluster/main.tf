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

# Keep the integration harness lightweight by reusing the account's default VPC.
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
  # Only test in AZs that support the chosen instance type so the run is predictable.
  supported_azs = [
    for az in data.aws_availability_zones.available.names :
    az if contains(data.aws_ec2_instance_type_offerings.supported.locations, az)
  ]
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
