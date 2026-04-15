variable "alb_name" {
  description = "Human-readable name for the ALB resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project name used in common tags"
  type        = string
}

variable "team_name" {
  description = "Owning team name used in common tags"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB security group should be created"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where the ALB should be deployed"
  type        = list(string)
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach the ALB over HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
