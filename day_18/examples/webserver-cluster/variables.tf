variable "region" {
  description = "AWS region where the integration test stack should run"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Base name for the integration test cluster"
  type        = string
  default     = "day18-integration"
}

variable "environment" {
  description = "Deployment environment for the integration test"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project tag value used by the integration harness"
  type        = string
  default     = "day18-automated-testing"
}

variable "team_name" {
  description = "Owner tag value used by the integration harness"
  type        = string
  default     = "EveOps"
}

variable "instance_type" {
  description = "EC2 instance type used by the test cluster"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of instances in the test ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the test ASG"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of instances for the integration test"
  type        = number
  default     = 1
}

variable "server_port" {
  description = "Application port for the integration test"
  type        = number
  default     = 8080
}

variable "server_text" {
  description = "Text returned by the integration test app"
  type        = string
  default     = "Hello from Day 18 Integration"
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
