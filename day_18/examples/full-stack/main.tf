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

resource "random_id" "suffix" {
  byte_length = 3
}

module "vpc" {
  source = "../../modules/networking/vpc"

  vpc_name            = "${var.vpc_name}-${random_id.suffix.hex}"
  environment         = var.environment
  project_name        = var.project_name
  team_name           = var.team_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
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
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.public_subnet_ids
  allowed_cidr_blocks        = var.allowed_cidr_blocks
  enable_detailed_monitoring = var.enable_detailed_monitoring
}
