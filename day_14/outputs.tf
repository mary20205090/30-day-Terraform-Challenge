output "primary_region_name" {
  description = "Region used by the default AWS provider"
  value       = data.aws_region.primary.name
}

output "secondary_region_name" {
  description = "Region used by the aliased AWS provider"
  value       = data.aws_region.secondary.name
}

output "primary_bucket_name" {
  description = "Name of the primary S3 bucket in the default region"
  value       = aws_s3_bucket.primary.bucket
}

output "replica_bucket_name" {
  description = "Name of the replica S3 bucket in the aliased region"
  value       = aws_s3_bucket.replica.bucket
}

output "replication_role_arn" {
  description = "IAM role used by S3 replication"
  value       = aws_iam_role.replication.arn
}
