variable "region" {
  description = "AWS region for the Day 5 load-balanced web app"
  type        = string
  default     = "us-west-2"
}

variable "project_name" {
  description = "Name prefix for Day 5 resources"
  type        = string
  default     = "day5-web-app"
}

variable "environment" {
  description = "Environment label applied to the resources"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type used by the Auto Scaling Group"
  type        = string
  default     = "t3.micro"
}

variable "server_port" {
  description = "Port the EC2 instances use to serve the web page"
  type        = number
  default     = 8080
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
  default     = 5
}

variable "desired_capacity" {
  description = "Desired number of instances in the ASG"
  type        = number
  default     = 2
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the ALB on port 80"
  type        = list(string)
  default     = ["0.0.0.0/0"]
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
