variable "primary_region" {
  description = "Primary AWS region for the default provider"
  type        = string
  default     = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS region used by the aliased provider"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Prefix used in Day 14 resource names"
  type        = string
  default     = "day14-multi-provider"
}

variable "environment" {
  description = "Environment tag for the Day 14 lab"
  type        = string
  default     = "lab"
}
