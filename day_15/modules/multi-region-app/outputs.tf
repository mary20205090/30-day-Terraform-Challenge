output "primary_bucket_name" {
  description = "Name of the primary S3 bucket"
  value       = aws_s3_bucket.primary.bucket
}

output "replica_bucket_name" {
  description = "Name of the replica S3 bucket"
  value       = aws_s3_bucket.replica.bucket
}

output "primary_bucket_arn" {
  description = "ARN of the primary S3 bucket"
  value       = aws_s3_bucket.primary.arn
}

output "replica_bucket_arn" {
  description = "ARN of the replica S3 bucket"
  value       = aws_s3_bucket.replica.arn
}
