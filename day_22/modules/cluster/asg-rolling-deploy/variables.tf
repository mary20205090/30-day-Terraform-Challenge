variable "cluster_name" {
  description = "Short name prefix used to build rolling ASG resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "production"], var.environment)
    error_message = "Environment must be dev, staging, or production."
  }
}

variable "project_name" {
  description = "Project name used in common tags"
  type        = string
}

variable "team_name" {
  description = "Owning team name used in common tags"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for the Auto Scaling Group"
  type        = string

  validation {
    condition     = can(regex("^t[23]\\.", var.instance_type))
    error_message = "Instance type must be a t2 or t3 family type."
  }
}

variable "min_size" {
  description = "Minimum number of instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired number of instances when the ASG is created"
  type        = number
}

variable "server_port" {
  description = "Application port exposed by the EC2 instances"
  type        = number
  default     = 8080
}

variable "vpc_id" {
  description = "VPC where the ASG security group should be created"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs where the ASG instances should launch"
  type        = list(string)
}

variable "target_group_arns" {
  description = "Target groups that should receive traffic from the ASG"
  type        = list(string)
  default     = []
}

variable "health_check_type" {
  description = "Health check type for the ASG"
  type        = string
  default     = "ELB"

  validation {
    condition     = contains(["EC2", "ELB"], var.health_check_type)
    error_message = "Health check type must be EC2 or ELB."
  }
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB allowed to reach the instances"
  type        = string
}

variable "user_data" {
  description = "User data script used to configure instances at boot"
  type        = string
  default     = null
}

variable "enable_detailed_monitoring" {
  description = "Enable EC2 detailed monitoring in the launch template"
  type        = bool
  default     = true
}

variable "ami_name_pattern" {
  description = "AMI name pattern used to look up a recent Ubuntu image"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ami_owner" {
  description = "AWS account ID that owns the Ubuntu AMI"
  type        = string
  default     = "099720109477"
}

variable "custom_tags" {
  description = "Additional tags to merge into the common tag map"
  type        = map(string)
  default     = {}
}
