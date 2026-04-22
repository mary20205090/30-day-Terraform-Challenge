variable "name" {
  description = "Name prefix for EC2 resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EC2 instance security group."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances. Amazon Linux 2023 is recommended."
  type        = string
}

variable "key_name" {
  description = "EC2 key pair name for SSH access. Omit in dev if not needed."
  type        = string
  default     = null
}

variable "allowed_http_security_group_ids" {
  description = "Security groups allowed to reach the instances on HTTP."
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
