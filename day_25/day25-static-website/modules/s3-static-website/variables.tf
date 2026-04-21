variable "bucket_name" {
  description = "Globally unique name for the S3 bucket."
  type        = string

  validation {
    condition = (
      length(var.bucket_name) >= 3 &&
      length(var.bucket_name) <= 63 &&
      can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.bucket_name)) &&
      !can(regex("\\.\\.", var.bucket_name))
    )
    error_message = "Bucket name must be 3-63 characters, lowercase, and contain only letters, numbers, dots, or hyphens."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "index_document" {
  description = "The index document for the website."
  type        = string
  default     = "index.html"

  validation {
    condition     = endswith(var.index_document, ".html")
    error_message = "Index document must be an HTML file."
  }
}

variable "error_document" {
  description = "The error document for the website."
  type        = string
  default     = "error.html"

  validation {
    condition     = endswith(var.error_document, ".html")
    error_message = "Error document must be an HTML file."
  }
}

variable "enable_cloudfront" {
  description = "Whether to create a CloudFront distribution in front of the S3 website endpoint."
  type        = bool
  default     = true
}
