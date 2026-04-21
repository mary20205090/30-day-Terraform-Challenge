variable "region" {
  description = "AWS region for bootstrap resources."
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
  default     = "mary-mutua-day25-terraform-state-718417034043"
}

variable "lock_table_name" {
  description = "DynamoDB table name for Terraform state locking."
  type        = string
  default     = "terraform-state-locks-day25"
}

variable "owner" {
  description = "Owner tag for bootstrap resources."
  type        = string
  default     = "terraform-challenge"
}
