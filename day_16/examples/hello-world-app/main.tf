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

# Use the default VPC to keep the Day 16 example lightweight and easy to rerun.
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "random_id" "suffix" {
  byte_length = 3
}

# Treat this example like a real consumer of the reusable service module.
module "hello_world_app" {
  source = "../../modules/services/hello-world-app"

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
