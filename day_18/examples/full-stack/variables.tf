variable "region" {
  description = "AWS region where the end-to-end stack should run"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "Base name for the end-to-end VPC"
  type        = string
  default     = "day18-e2e-vpc"
}

variable "cluster_name" {
  description = "Base name for the end-to-end app cluster"
  type        = string
  default     = "day18-e2e-app"
}

variable "environment" {
  description = "Deployment environment for the end-to-end test"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project tag value used by the end-to-end harness"
  type        = string
  default     = "day18-automated-testing"
}

variable "team_name" {
  description = "Owner tag value used by the end-to-end harness"
  type        = string
  default     = "EveOps"
}

variable "vpc_cidr" {
  description = "CIDR block for the end-to-end VPC"
  type        = string
  default     = "10.60.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs used for the end-to-end VPC"
  type        = list(string)
  default     = ["10.60.1.0/24", "10.60.2.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type used by the end-to-end app"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of instances in the end-to-end ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the end-to-end ASG"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of instances in the end-to-end ASG"
  type        = number
  default     = 1
}

variable "server_port" {
  description = "Application port for the end-to-end stack"
  type        = number
  default     = 8080
}

variable "server_text" {
  description = "Text returned by the end-to-end app"
  type        = string
  default     = "Hello from Day 18 End-to-End"
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
