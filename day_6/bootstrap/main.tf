# This bootstrap configuration creates the remote backend infrastructure.
# It is kept separate because Terraform cannot use an S3 backend until the
# bucket and locking table already exist.

provider "aws" {
  region = "us-east-1"
}

# Create the S3 bucket that will store Terraform state remotely.
# The bucket name must be globally unique across AWS.
resource "aws_s3_bucket" "terraform_state" {
  bucket = "mary-mutua-30day-terraform-state-20260325-a1b2"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "terraform-remote-state"
    Environment = "dev"
    Terraform   = "true"
  }
}

# Enable versioning so older state revisions can be recovered if needed.
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

# Create the DynamoDB table Terraform will use for state locking.
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-state-locks"
    Environment = "dev"
    Terraform   = "true"
  }
}
