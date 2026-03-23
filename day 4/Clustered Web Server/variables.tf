variable "region" {
  description = "AWS region for the clustered web server"
  type        = string
  default     = "us-west-2"
}

variable "server_port" {
  description = "The port the cluster will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "instance_type" {
  description = "EC2 instance type for cluster members"
  type        = string
  default     = "t2.micro"
}

variable "cluster_name" {
  description = "Name prefix for clustered web server resources"
  type        = string
  default     = "clustered-web-server"
}

variable "environment" {
  description = "Environment label applied to cluster resources"
  type        = string
  default     = "dev"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "min_size" {
  description = "Minimum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 5
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances in the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "ami_name_pattern" {
  description = "AMI name pattern used to look up the operating system image"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ami_owner" {
  description = "AWS account ID that owns the AMI"
  type        = string
  default     = "099720109477"
}
