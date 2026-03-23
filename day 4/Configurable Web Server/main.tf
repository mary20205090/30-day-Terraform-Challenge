# Day 4 lab notes:
# This file shows the Terraform changes for the "Intro to the Terraform
# Data Block" lab, especially Tasks 2 through 6.
# This version also includes the minimal supporting resources needed for
# validation in this standalone folder.

# Configure the AWS provider for the lab region.
provider "aws" {
  region = "us-west-2"
}

# Task 1:
# Query AWS to discover the current region. Terraform stores the result
# so we can reference it later in the configuration.
data "aws_region" "current" {}

# Task 2:
# Define the VPC and add a Region tag that uses the region data source.
# This follows the lab instruction:
# data.<type>.<name>.<attribute>
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = var.vpc_name
    Environment = "demo_environment"
    Terraform   = "true"
    # The lab text uses .name, but newer AWS provider versions deprecate it.
    # Using .id keeps the same region code value without the warning.
    Region      = data.aws_region.current.id
  }
}

# Task 3:
# Query the availability zones in the current region. This keeps the
# configuration flexible because AWS returns the valid AZs for whichever
# region is active.
data "aws_availability_zones" "available" {}

# Task 4:
# Create the private subnets and use the availability zone data source
# instead of hardcoding AZ names. The expression below converts the AZ list
# to an indexable list, then selects the AZ that matches each subnet value.
resource "aws_subnet" "private_subnets" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = tolist(data.aws_availability_zones.available.names)[each.value]

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

# Supporting resource:
# Create at least one public subnet so the EC2 instance from Task 6 has a
# subnet to launch into. We reuse the same AZ data source pattern from the lab.
resource "aws_subnet" "public_subnets" {
  for_each                = var.public_subnets
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone       = tolist(data.aws_availability_zones.available.names)[each.value]
  map_public_ip_on_launch = true

  tags = {
    Name      = each.key
    Terraform = "true"
  }
}

# Supporting resource:
# Create a simple security group for the EC2 instance so the reference used
# in Task 6 exists in this standalone lab folder.
resource "aws_security_group" "vpc_ping" {
  name        = "vpc-ping"
  description = "Allow basic traffic for the lab web server"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ICMP ping"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "vpc-ping"
    Terraform = "true"
  }
}

# Task 5:
# Look up the most recent Ubuntu 22.04 AMI from Canonical.
# This is better than hardcoding an AMI ID because AMI IDs vary by region
# and newer images are published over time.
data "aws_ami" "ubuntu_22_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"]
}

# Task 6:
# Update the EC2 instance so the ami argument uses the AMI returned by the
# ubuntu_22_04 data source.
#
# Important:
# This block now uses the supporting public subnet and security group defined
# in this same file.
resource "aws_instance" "web_server" {
  ami                         = data.aws_ami.ubuntu_22_04.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_subnets["public_subnet_1"].id
  vpc_security_group_ids      = [aws_security_group.vpc_ping.id]
  associate_public_ip_address = true

  tags = {
    Name = "Web EC2 Server"
  }
}
