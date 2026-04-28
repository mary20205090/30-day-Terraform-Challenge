// Default to the account VPC for the lab, but allow tfvars to override it.
data "aws_vpc" "default" {
  default = true
}

// Pull the latest Amazon Linux 2023 AMI so the launch template stays portable.
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  effective_vpc_id = coalesce(var.vpc_id, data.aws_vpc.default.id)
}

data "aws_ec2_instance_type_offerings" "selected" {
  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }

  location_type = "availability-zone"
}

// Some AZs do not support every instance type, so only use compatible subnets.
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [local.effective_vpc_id]
  }

  filter {
    name   = "availability-zone"
    values = data.aws_ec2_instance_type_offerings.selected.locations
  }
}

locals {
  effective_ami_id             = coalesce(var.ami_id, data.aws_ami.amazon_linux_2023.id)
  effective_public_subnet_ids  = length(var.public_subnet_ids) > 0 ? var.public_subnet_ids : data.aws_subnets.selected.ids
  effective_private_subnet_ids = length(var.private_subnet_ids) > 0 ? var.private_subnet_ids : local.effective_public_subnet_ids

  common_tags = {
    Owner = var.owner
    Day   = "26"
  }
}

// The ALB is the public entry point and owns listener/target group wiring.
module "alb" {
  source = "../../modules/alb"

  name                   = var.app_name
  vpc_id                 = local.effective_vpc_id
  subnet_ids             = local.effective_public_subnet_ids
  environment            = var.environment
  high_request_threshold = var.high_request_threshold
  tags                   = local.common_tags
}

// The EC2 module produces the launch template consumed by the ASG.
module "ec2" {
  source = "../../modules/ec2"

  name                            = var.app_name
  vpc_id                          = local.effective_vpc_id
  ami_id                          = local.effective_ami_id
  instance_type                   = var.instance_type
  key_name                        = var.key_name
  allowed_http_security_group_ids = [module.alb.alb_security_group_id]
  environment                     = var.environment
  tags                            = local.common_tags
}

// The ASG closes the loop: launch EC2 instances and register them with the ALB target group.
module "asg" {
  source = "../../modules/asg"

  name                    = var.app_name
  launch_template_id      = module.ec2.launch_template_id
  launch_template_version = module.ec2.launch_template_version
  subnet_ids              = local.effective_private_subnet_ids
  target_group_arns       = [module.alb.target_group_arn]
  min_size                = var.min_size
  max_size                = var.max_size
  desired_capacity        = var.desired_capacity
  cpu_scale_out_threshold = var.cpu_scale_out_threshold
  cpu_scale_in_threshold  = var.cpu_scale_in_threshold
  enable_dashboard        = var.enable_dashboard
  environment             = var.environment
  tags                    = local.common_tags
}
