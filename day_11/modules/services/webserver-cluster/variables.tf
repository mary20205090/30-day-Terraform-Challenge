variable "cluster_name" {
  description = "Name prefix used for Day 11 webserver resources"
  type        = string
}

variable "region" {
  description = "AWS region for the Day 11 deployment"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Deployment environment: dev, staging, or production"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "use_existing_vpc" {
  description = "When true, use the default VPC. When false, create a new VPC and subnet."
  type        = bool
  default     = true
}

variable "enable_detailed_monitoring" {
  description = "Set to true or false to override the environment-based monitoring default. Leave null to follow the environment default."
  type        = bool
  default     = null
  nullable    = true
}

variable "create_dns_record" {
  description = "Set to true or false to override the environment-based DNS default. Leave null to follow the environment default."
  type        = bool
  default     = null
  nullable    = true
}

variable "domain_name" {
  description = "Record name to create when DNS is enabled"
  type        = string
  default     = "web.example.com"
}

variable "hosted_zone_name" {
  description = "Public Route53 hosted zone used when DNS is enabled"
  type        = string
  default     = "example.com"
}

variable "ami_name_pattern" {
  description = "AMI name pattern used to locate a recent Ubuntu image"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ami_owner" {
  description = "AWS account ID that owns the Ubuntu AMI"
  type        = string
  default     = "099720109477"
}
