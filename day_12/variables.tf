variable "region" {
  description = "AWS region for the Day 12 deployment"
  type        = string
  default     = "us-west-2"
}

# Inputs for the rolling zero-downtime deployment demo.
variable "cluster_name" {
  description = "Name prefix used for the Day 12 deployment"
  type        = string
  default     = "day12-web"
}

variable "instance_type" {
  description = "EC2 instance type for the zero-downtime and blue/green demos"
  type        = string
  default     = "t3.micro"
}

variable "server_port" {
  description = "Application port served by the EC2 instances"
  type        = number
  default     = 8080
}

variable "min_size" {
  description = "Minimum ASG size for the rolling zero-downtime demo"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum ASG size for the rolling zero-downtime demo"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Desired instance count for the rolling zero-downtime demo"
  type        = number
  default     = 1
}

variable "app_version" {
  description = "Visible response text version for the rolling deployment demo"
  type        = string
  # default     = "v1"
  default = "v2"
}

# Inputs for the blue/green deployment demo.
variable "active_environment" {
  description = "Which environment is currently active for the blue/green listener: blue or green"
  type        = string
  # default     = "blue"
  default = "green"

  validation {
    condition     = contains(["blue", "green"], var.active_environment)
    error_message = "active_environment must be blue or green."
  }
}

variable "blue_version" {
  description = "Visible response text for the blue environment"
  type        = string
  default     = "v1"
}

variable "green_version" {
  description = "Visible response text for the green environment"
  type        = string
  default     = "v2"
}

# Keep blue/green capacity configurable so the rolling demo can be tested separately on small AWS quotas.
variable "blue_green_min_size" {
  description = "Minimum ASG size for the blue/green environments"
  type        = number
  default     = 1
}

variable "blue_green_max_size" {
  description = "Maximum ASG size for the blue/green environments"
  type        = number
  default     = 1
}

variable "blue_green_desired_capacity" {
  description = "Desired ASG size for the blue/green environments"
  type        = number
  default     = 1
}

# AMI lookup inputs keep the launch templates portable.
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
