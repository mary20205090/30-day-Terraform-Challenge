variable "region" {
  description = "AWS region for the Day 26 dev environment."
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Short name prefix for the scalable web application."
  type        = string
  default     = "day26-web"

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.app_name)) && length(var.app_name) <= 16
    error_message = "app_name must contain only letters, numbers, hyphens, and be 16 characters or fewer."
  }
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "ami_id" {
  description = "Optional AMI ID. When null, the latest Amazon Linux 2023 AMI is used."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "EC2 instance type for the web tier."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Optional EC2 key pair name. Null keeps SSH closed for this dev lab."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "Optional VPC ID. When null, the default VPC is used."
  type        = string
  default     = null
}

variable "public_subnet_ids" {
  description = "Optional public subnet IDs for the ALB. When empty, default VPC subnets are used."
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "Optional subnet IDs for ASG instances. When empty, default VPC subnets are used for the lab."
  type        = list(string)
  default     = []
}

variable "min_size" {
  description = "Minimum number of instances in the ASG."
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the ASG."
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired number of instances when the ASG starts."
  type        = number
  default     = 2
}

variable "cpu_scale_out_threshold" {
  description = "Average CPU percentage that triggers scale out."
  type        = number
  default     = 70
}

variable "cpu_scale_in_threshold" {
  description = "Average CPU percentage that triggers scale in."
  type        = number
  default     = 30
}

variable "high_request_threshold" {
  description = "RequestCountPerTarget threshold for the ALB request alarm."
  type        = number
  default     = 1000
}

variable "enable_dashboard" {
  description = "Whether to create the CloudWatch dashboard."
  type        = bool
  default     = true
}

variable "owner" {
  description = "Owner tag value for Day 26 resources."
  type        = string
  default     = "terraform-challenge"
}
