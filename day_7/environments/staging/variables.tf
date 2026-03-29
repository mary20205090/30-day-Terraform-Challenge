variable "environment_name" {
  description = "Name of the environment this folder represents"
  type        = string
  default     = "staging"
}

variable "region" {
  description = "AWS region for the staging environment"
  type        = string
  default     = "us-west-2"
}

variable "instance_type" {
  description = "EC2 instance type for the staging environment"
  type        = string
  default     = "t3.small"
}
