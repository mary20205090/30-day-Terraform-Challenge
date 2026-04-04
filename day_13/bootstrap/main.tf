# This bootstrap configuration creates the Day 13 remote backend first.
# It must run with local state because Terraform cannot use an S3 backend
# until the bucket and lock table already exist.

provider "aws" {
  region = "us-east-1"
}

# Create a dedicated state bucket for Day 13 so the lesson can be fully cleaned up afterward.
resource "aws_s3_bucket" "terraform_state" {
  bucket        = "mary-mutua-30day-terraform-state-day13-20260404-a1b3"
  force_destroy = true

  tags = {
    Name        = "day13-terraform-remote-state"
    Environment = "lab"
    Terraform   = "true"
  }
}

# Block public access because Terraform state may contain plaintext secrets.
resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning so accidental overwrites are recoverable.
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable default server-side encryption for the state bucket.
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Create a dedicated DynamoDB table for state locking in this lesson.
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks-day13"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-state-locks-day13"
    Environment = "lab"
    Terraform   = "true"
  }
}

output "state_bucket_name" {
  value       = aws_s3_bucket.terraform_state.bucket
  description = "Day 13 S3 bucket for remote Terraform state"
}

output "lock_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "Day 13 DynamoDB table for Terraform state locking"
}
