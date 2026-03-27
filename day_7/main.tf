# Store Day 7 state remotely in the same S3 backend pattern used on Day 6.
# When using workspaces with the S3 backend, Terraform keeps separate state
# files per workspace automatically.
terraform {
  backend "s3" {
    bucket         = "mary-mutua-30day-terraform-state-20260325-a1b2"
    key            = "day_7/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

# Configure the AWS provider for this workspace lab.
provider "aws" {
  region = "us-west-2"
}

# Look up the default VPC so we can reuse existing networking for a simple lab.
data "aws_vpc" "default" {
  default = true
}

# Fetch the subnets in the default VPC and place the instance in the first one.
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Look up a current Ubuntu AMI instead of hardcoding a region-specific AMI ID.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

# Use a map so each workspace can choose a different EC2 size while sharing
# the same Terraform code.
variable "instance_type" {
  description = "EC2 instance type per environment"
  type        = map(string)

  default = {
    dev        = "t3.micro"
    staging    = "t3.small"
    production = "t3.medium"
  }
}

# Build one EC2 instance whose behavior changes based on the active workspace.
# The workspace name is used for the instance type and tags.
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type[terraform.workspace]
  subnet_id                   = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true

  tags = {
    Name        = "web-${terraform.workspace}"
    Environment = terraform.workspace
    Terraform   = "true"
  }
}

# Output the current workspace so it is easy to see which environment is active.
output "current_workspace" {
  value       = terraform.workspace
  description = "The active Terraform workspace"
}

# Output the instance ID for quick verification after apply.
output "instance_id" {
  value       = aws_instance.web.id
  description = "EC2 instance ID for the active workspace"
}
