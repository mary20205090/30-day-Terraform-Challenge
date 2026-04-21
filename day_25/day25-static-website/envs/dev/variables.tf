variable "region" {
  description = "AWS region for regional resources."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Globally unique name for the S3 bucket."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "index_document" {
  description = "The index document for the website."
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The error document for the website."
  type        = string
  default     = "error.html"
}

variable "owner" {
  description = "Owner tag for all resources."
  type        = string
  default     = "terraform-challenge"
}

variable "enable_cloudfront" {
  description = "Whether to create CloudFront. Disable only when the AWS account is not verified for CloudFront yet."
  type        = bool
  default     = true
}
