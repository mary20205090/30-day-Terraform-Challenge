variable "region" {
  description = "AWS region for the Day 13 secrets lab"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Prefix used for Day 13 resources"
  type        = string
  default     = "day13-secrets"
}

variable "db_name" {
  description = "Name of the MySQL database to create"
  type        = string
  default     = "appdb"
}

variable "db_secret_name" {
  description = "Name of the AWS Secrets Manager secret that stores the database credentials"
  type        = string
  default     = "prod/db/credentials"
}

# Example of a secret-carrying variable: no default and marked sensitive so Terraform won't print it.
# This is only for testing overrides; the normal path is to read the password from Secrets Manager.
variable "db_password_override" {
  description = "Optional override password for testing. Leave unset in normal use."
  type        = string
  sensitive   = true
  default     = null
  nullable    = true
}
