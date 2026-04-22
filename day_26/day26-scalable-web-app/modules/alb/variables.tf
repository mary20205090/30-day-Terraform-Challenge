variable "name" {
  description = "Name prefix for the ALB and related resources."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.name)) && length(var.name) <= 16
    error_message = "Name must contain only letters, numbers, hyphens, and be 16 characters or fewer."
  }
}

variable "vpc_id" {
  description = "VPC ID where the ALB will be created."
  type        = string
}

variable "subnet_ids" {
  description = "List of public subnet IDs for the ALB. Use at least two AZs."
  type        = list(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least two public subnet IDs are required for an ALB."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "high_request_threshold" {
  description = "RequestCountPerTarget threshold for the optional ALB traffic alarm."
  type        = number
  default     = 1000
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
