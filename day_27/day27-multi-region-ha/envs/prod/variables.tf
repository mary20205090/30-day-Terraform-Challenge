variable "app_name" {
  description = "Application name prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "primary_ami_id" {
  description = "AMI ID for the primary region app instances"
  type        = string
}

variable "primary_vpc_cidr" {
  description = "Primary region VPC CIDR"
  type        = string
}

variable "primary_public_subnet_cidrs" {
  description = "Primary region public subnet CIDRs"
  type        = list(string)
}

variable "primary_private_subnet_cidrs" {
  description = "Primary region private subnet CIDRs"
  type        = list(string)
}

variable "primary_availability_zones" {
  description = "Primary region AZs"
  type        = list(string)
}

variable "secondary_ami_id" {
  description = "AMI ID for the secondary region app instances"
  type        = string
}

variable "secondary_vpc_cidr" {
  description = "Secondary region VPC CIDR"
  type        = string
}

variable "secondary_public_subnet_cidrs" {
  description = "Secondary region public subnet CIDRs"
  type        = list(string)
}

variable "secondary_private_subnet_cidrs" {
  description = "Secondary region private subnet CIDRs"
  type        = list(string)
}

variable "secondary_availability_zones" {
  description = "Secondary region AZs"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of instances in each region"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in each region"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired number of instances in each region"
  type        = number
  default     = 2
}

variable "cpu_scale_out_threshold" {
  description = "Average CPU threshold for scale out"
  type        = number
  default     = 70
}

variable "cpu_scale_in_threshold" {
  description = "Average CPU threshold for scale in"
  type        = number
  default     = 30
}

variable "db_name" {
  description = "Primary database name"
  type        = string
}

variable "db_username" {
  description = "Primary database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Primary database password"
  type        = string
  sensitive   = true
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  type        = string
}

variable "domain_name" {
  description = "Failover DNS name"
  type        = string
}
