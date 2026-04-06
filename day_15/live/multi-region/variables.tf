variable "primary_region" {
  description = "Primary AWS region for the multi-region module demo"
  type        = string
  default     = "us-east-1"
}

variable "replica_region" {
  description = "Replica AWS region for the multi-region module demo"
  type        = string
  default     = "us-west-2"
}

variable "app_name" {
  description = "Short base name for the multi-region demo"
  type        = string
  default     = "day15-multi-region"
}

variable "environment" {
  description = "Environment label used for tagging"
  type        = string
  default     = "lab"
}
