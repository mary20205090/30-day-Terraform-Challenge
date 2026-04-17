variable "region" {
  description = "AWS region for Day 22 integrated workflow"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Base cluster name for Day 22 staging environment"
  type        = string
  default     = "day22-integrated-staging"
}

variable "environment" {
  description = "Environment name for Day 22 workflow"
  type        = string
  default     = "staging"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "environment must be dev, staging, or production."
  }
}

variable "project_name" {
  description = "Project tag for Day 22 resources"
  type        = string
  default     = "day22-integrated-workflow"
}

variable "team_name" {
  description = "Team or owner tag value"
  type        = string
  default     = "EveOps"
}

variable "instance_type" {
  description = "EC2 instance type for Day 22 ASG"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t2.micro", "t2.small", "t2.medium", "t3.micro", "t3.small"], var.instance_type)
    error_message = "instance_type must be one of the approved sandbox instance types."
  }
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 1
}

variable "server_port" {
  description = "Application port"
  type        = number
  default     = 8080
}

variable "server_text" {
  description = "Response body text served by user data script"
  type        = string
  default     = "Hello from Day 22 integrated workflow"
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
