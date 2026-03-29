# This environment uses its own folder and its own backend key.
# That means production has its own code entry point and its own state file.

provider "aws" {
  region = var.region
}

# Reuse the default VPC so the lab stays small and easy to understand.
data "aws_vpc" "default" {
  default = true
}

# Fetch the default VPC subnets and place the instance in the first one.
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Look up a recent Ubuntu AMI instead of hardcoding a region-specific ID.
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

# This EC2 instance is managed only by the production folder and production
# state file.
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  associate_public_ip_address = true

  tags = {
    Name        = "web-${var.environment_name}"
    Environment = var.environment_name
    Terraform   = "true"
  }
}
