provider "aws" {
  region = var.region
}

# This lesson uses local state so everything can be destroyed cleanly after practice.
# In a real environment, remote state must still be protected because secrets can leak into it.
# The production-ready S3 backend example for this lesson lives in backend.tf.example.

# Use the default VPC to keep this lab focused on secret handling rather than networking.
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Read the bootstrap secret from AWS Secrets Manager instead of storing it in Terraform code.
data "aws_secretsmanager_secret" "db_credentials" {
  name = var.db_secret_name
}

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

# Decode the JSON secret once in locals so resources stay cleaner.
locals {
  db_credentials = jsondecode(
    data.aws_secretsmanager_secret_version.db_credentials.secret_string
  )
  effective_db_password = var.db_password_override != null ? var.db_password_override : local.db_credentials["password"]
}

# Keep networking simple so the lesson stays focused on secret handling.
resource "aws_security_group" "db" {
  name_prefix = "${var.project_name}-db-"
  description = "Database access security group for Day 13"
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_vpc_security_group_ingress_rule" "mysql" {
  security_group_id = aws_security_group.db.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.db.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.project_name}-subnet-group"
  subnet_ids = slice(data.aws_subnets.default.ids, 0, 2)
}

# The password comes from Secrets Manager at apply time, but it can still appear in state.
resource "aws_db_instance" "example" {
  identifier_prefix    = "${var.project_name}-"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 10
  db_name              = var.db_name
  username             = local.db_credentials["username"]
  password             = local.effective_db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [
    aws_security_group.db.id
  ]
  skip_final_snapshot = true
  publicly_accessible = true
}
