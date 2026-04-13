variable "region" {
  description = "AWS region for Day 20 dev workflow simulation"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Base cluster name for Day 20 dev environment"
  type        = string
  default     = "day20-workflow-dev"
}

variable "environment" {
  description = "Environment name for Day 20 workflow"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project tag for Day 20 resources"
  type        = string
  default     = "day20-workflow"
}

variable "team_name" {
  description = "Team or owner tag value"
  type        = string
  default     = "EveOps"
}

variable "instance_type" {
  description = "EC2 instance type for Day 20 ASG"
  type        = string
  default     = "t3.micro"
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
  default     = "Hello from Day 20 v3"
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
