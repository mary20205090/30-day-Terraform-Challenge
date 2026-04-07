variable "region" {
  description = "AWS region for the Day 16 example"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Base name used for the example deployment"
  type        = string
  default     = "day16-hello-world"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "project_name" {
  description = "Project name used in resource tags"
  type        = string
  default     = "30-day-terraform-challenge"
}

variable "team_name" {
  description = "Team name used in resource tags"
  type        = string
  default     = "EveOps"
}

variable "instance_type" {
  description = "EC2 instance type for the example cluster"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = can(regex("^t[23]\\.", var.instance_type))
    error_message = "Instance type must be a t2 or t3 family type."
  }
}

variable "min_size" {
  description = "Minimum ASG size"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum ASG size"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired ASG size"
  type        = number
  default     = 1
}

variable "server_port" {
  description = "Port served by the app instances"
  type        = number
  default     = 8080
}

variable "server_text" {
  description = "Text displayed by the Day 16 hello-world app"
  type        = string
  default     = "Hello from Day 16"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_detailed_monitoring" {
  description = "Enable EC2 detailed monitoring"
  type        = bool
  default     = true
}
