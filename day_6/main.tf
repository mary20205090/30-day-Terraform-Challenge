# Configure Terraform to store state remotely in S3 and use DynamoDB for
# state locking. The bucket and table must exist before this backend can work,
# so they are created separately in the bootstrap folder.
terraform {
  backend "s3" {
    bucket         = "mary-mutua-30day-terraform-state-20260325-a1b2"
    key            = "day_6/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

# Configure the AWS provider. For this Day 6 lab, we only need one region
# because the goal is to deploy a small resource and inspect Terraform state.
provider "aws" {
  region = "us-west-2"
}

# Look up the default VPC in the chosen region so we can place the security
# group into an existing network instead of creating new networking resources.
data "aws_vpc" "default" {
  default = true
}

# Create a simple security group that we can use to study Terraform state.
# A security group is a good fit for this lab because it is small, easy to
# deploy, and still has enough attributes to inspect in terraform.tfstate.
resource "aws_security_group" "example" {
  name        = "day6-state-demo-sg"
  description = "Simple security group for inspecting Terraform state"
  vpc_id      = data.aws_vpc.default.id

  # Allow inbound HTTP traffic on port 80 from anywhere. This gives the
  # resource a clear ingress rule that will appear in the state file.
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic. This is a common default rule and will also
  # be visible in the recorded resource attributes inside the state file.
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Tags make the resource easier to identify in AWS and also provide more
  # attributes to observe when reading terraform.tfstate and terraform state show.
  tags = {
    Name        = "day6-state-demo-sg"
    Environment = "dev"
    Terraform   = "true"
  }
}

# Expose the security group ID after apply. This makes it easy to confirm
# the resource was created and also shows how Terraform stores output values.
output "security_group_id" {
  value       = aws_security_group.example.id
  description = "ID of the Day 6 demo security group"
}
