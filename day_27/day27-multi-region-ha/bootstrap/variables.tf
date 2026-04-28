variable "region" {
  description = "AWS region for the remote state backend resources."
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Day 27 Terraform state."
  type        = string
  default     = "mary-mutua-day27-tf-state-use1-718417034043-20260428"
}

variable "lock_table_name" {
  description = "DynamoDB table name for Day 27 Terraform state locking."
  type        = string
  default     = "terraform-state-locks-day27"
}

variable "tags" {
  description = "Tags for backend bootstrap resources."
  type        = map(string)
  default = {
    Owner     = "terraform-challenge"
    Project   = "multi-region-ha"
    ManagedBy = "terraform"
  }
}
