variable "vpc_name" {
  description = "Name used for the VPC and related networking resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "project_name" {
  description = "Project name used in common tags"
  type        = string
}

variable "team_name" {
  description = "Owning team name used in common tags"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the test VPC"
  type        = string
  default     = "10.42.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks used for public subnets"
  type        = list(string)
  default     = ["10.42.1.0/24", "10.42.2.0/24"]
}

variable "custom_tags" {
  description = "Additional tags to merge into the common tag map"
  type        = map(string)
  default     = {}
}
