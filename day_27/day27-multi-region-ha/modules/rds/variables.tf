variable "identifier" {
  description = "Unique identifier for the RDS instance"
  type        = string
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage size in GB"
  type        = number
  default     = 20
}

variable "backup_retention_period" {
  description = "Automated backup retention for the primary DB; must stay > 0 when creating replicas"
  type        = number
  default     = 1
}

variable "kms_key_id" {
  description = "Optional KMS key ARN or alias for encrypted RDS; cross-region replicas need a destination-region key"
  type        = string
  default     = null
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
}

variable "db_username" {
  description = "Master database username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "Private subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the RDS security group"
  type        = string
}

variable "app_security_group_id" {
  description = "Application security group ID allowed to reach the DB"
  type        = string
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment for the primary instance"
  type        = bool
  default     = true
}

variable "is_replica" {
  description = "Set to true when creating a cross-region read replica"
  type        = bool
  default     = false
}

variable "replicate_source_db" {
  description = "ARN of the primary RDS instance to replicate from"
  type        = string
  default     = null
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "region" {
  description = "AWS region this RDS instance is deployed in"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
