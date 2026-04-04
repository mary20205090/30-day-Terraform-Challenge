terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Default provider for the primary region.
provider "aws" {
  region = var.primary_region
}

# Aliased provider for the secondary region.
provider "aws" {
  alias  = "us_west"
  region = var.secondary_region
}

# Use account identity in the bucket names to reduce global naming collisions.
data "aws_caller_identity" "current" {}

# These data sources make the active provider regions easy to verify in outputs.
data "aws_region" "primary" {}

data "aws_region" "secondary" {
  provider = aws.us_west
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# The source bucket lives in the default provider region.
resource "aws_s3_bucket" "primary" {
  bucket = "${var.project_name}-${data.aws_caller_identity.current.account_id}-${random_id.bucket_suffix.hex}-primary"

  tags = {
    Name        = "${var.project_name}-primary"
    Environment = var.environment
    Terraform   = "true"
  }
}

# The replica bucket lives in the aliased provider region.
resource "aws_s3_bucket" "replica" {
  provider = aws.us_west
  bucket   = "${var.project_name}-${data.aws_caller_identity.current.account_id}-${random_id.bucket_suffix.hex}-replica"

  tags = {
    Name        = "${var.project_name}-replica"
    Environment = var.environment
    Terraform   = "true"
  }
}

# Replication requires versioning on both source and destination buckets.
resource "aws_s3_bucket_versioning" "primary" {
  bucket = aws_s3_bucket.primary.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "replica" {
  provider = aws.us_west
  bucket   = aws_s3_bucket.replica.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt both buckets by default to follow the safer patterns we covered earlier.
resource "aws_s3_bucket_server_side_encryption_configuration" "primary" {
  bucket = aws_s3_bucket.primary.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "replica" {
  provider = aws.us_west
  bucket   = aws_s3_bucket.replica.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "primary" {
  bucket = aws_s3_bucket.primary.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "replica" {
  provider = aws.us_west
  bucket   = aws_s3_bucket.replica.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 assumes this role when copying objects from the source bucket to the replica bucket.
resource "aws_iam_role" "replication" {
  name = "${var.project_name}-replication-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "replication" {
  name = "${var.project_name}-replication-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.primary.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObjectVersionForReplication",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging"
        ]
        Resource = [
          "${aws_s3_bucket.primary.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ]
        Resource = [
          "${aws_s3_bucket.replica.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

# The replication rule demonstrates a real multi-region provider use case.
# Newer S3 replication APIs require delete marker replication to be declared too.
resource "aws_s3_bucket_replication_configuration" "replication" {
  bucket = aws_s3_bucket.primary.id
  role   = aws_iam_role.replication.arn

  rule {
    id     = "replicate-all"
    status = "Enabled"

    filter {}

    delete_marker_replication {
      status = "Disabled"
    }

    destination {
      bucket        = aws_s3_bucket.replica.arn
      storage_class = "STANDARD"
    }
  }

  depends_on = [
    aws_s3_bucket_versioning.primary,
    aws_s3_bucket_versioning.replica,
    aws_iam_role_policy_attachment.replication
  ]
}
