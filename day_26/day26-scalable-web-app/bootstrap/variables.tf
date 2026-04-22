variable "region" {
  description = "AWS region for the remote state backend resources."
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Day 26 Terraform state."
  type        = string
  default     = "mary-mutua-day26-tf-state-use1-718417034043-20260423"
}

variable "lock_table_name" {
  description = "DynamoDB table name for Day 26 Terraform state locking."
  type        = string
  default     = "terraform-state-locks-day26"
}

variable "tags" {
  description = "Tags for backend bootstrap resources."
  type        = map(string)
  default = {
    Project   = "day26-scalable-web-app"
    ManagedBy = "terraform"
    Day       = "26"
  }
}
