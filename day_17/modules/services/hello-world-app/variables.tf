variable "cluster_name" {
  description = "Base name used to build the app resources"
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

variable "instance_type" {
  description = "EC2 instance type for the app cluster"
  type        = string

  validation {
    condition     = can(regex("^t[23]\\.", var.instance_type))
    error_message = "Instance type must be a t2 or t3 family type."
  }
}

variable "min_size" {
  description = "Minimum number of web instances"
  type        = number
}

variable "max_size" {
  description = "Maximum number of web instances"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of web instances"
  type        = number
}

variable "server_port" {
  description = "Port served by the hello-world application"
  type        = number
  default     = 8080
}

variable "server_text" {
  description = "Text returned by the web app"
  type        = string
  default     = "Hello World"
}

variable "vpc_id" {
  description = "VPC ID where the app should be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs used by both the ALB and ASG"
  type        = list(string)
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

variable "custom_tags" {
  description = "Additional tags to merge into the common tag map"
  type        = map(string)
  default     = {}
}
