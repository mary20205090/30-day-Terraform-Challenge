# This environment uses its own folder and its own backend key.
# That means production has its own code entry point and its own state file.

provider "aws" {
  region = var.region
}

# Read outputs from the dev state file to demonstrate how one configuration
# can safely consume values exposed by another configuration.
data "terraform_remote_state" "dev_network" {
  backend = "s3"

  config = {
    bucket = "mary-mutua-30day-terraform-state-20260325-a1b2"
    key    = "environments/dev/terraform.tfstate"
    region = "us-east-1"
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
  subnet_id                   = data.terraform_remote_state.dev_network.outputs.subnet_id
  associate_public_ip_address = true

  tags = {
    Name        = "web-${var.environment_name}"
    Environment = var.environment_name
    Terraform   = "true"
  }
}
