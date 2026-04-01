# Day 10: loops and conditionals. This folder is intentionally standalone.

provider "aws" {
  region = var.region
}

# ---------------------------------------------------------------------------
# COUNT DEMO (disabled by default)
# ---------------------------------------------------------------------------
resource "aws_iam_user" "count_users" {
  count = var.enable_count_demo ? length(var.count_user_names) : 0
  name  = var.count_user_names[count.index]
}

# ---------------------------------------------------------------------------
# FOR_EACH DEMO (disabled by default)
# ---------------------------------------------------------------------------
resource "aws_iam_user" "foreach_users" {
  for_each = var.enable_foreach_demo ? var.foreach_user_names : toset([])
  name     = each.value
}

resource "aws_iam_user" "foreach_users_with_tags" {
  for_each = var.enable_foreach_tags_demo ? var.users : {}
  name     = each.key

  tags = {
    Department = each.value.department
  }
}

# ---------------------------------------------------------------------------
# CONDITIONAL INSTANCE TYPE DEMO
# ---------------------------------------------------------------------------
locals {
  instance_type = var.environment == "production" ? "t3.small" : "t3.micro"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_name_pattern]
  }

  owners = [var.ami_owner]
}

resource "aws_instance" "conditional_example" {
  count         = var.enable_conditional_instance ? 1 : 0
  ami           = data.aws_ami.ubuntu.id
  instance_type = local.instance_type

  tags = {
    Name        = "day10-conditional"
    Environment = var.environment
  }
}
