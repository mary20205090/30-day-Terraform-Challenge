output "bucket_name" {
  value       = aws_s3_bucket.website.id
  description = "Name of the S3 bucket."
}

output "website_endpoint" {
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
  description = "S3 website endpoint."
}

output "cloudfront_domain_name" {
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].domain_name : null
  description = "CloudFront distribution domain name. Null when CloudFront is disabled."
}

output "cloudfront_distribution_id" {
  value       = var.enable_cloudfront ? aws_cloudfront_distribution.website[0].id : null
  description = "CloudFront distribution ID. Null when CloudFront is disabled."
}
