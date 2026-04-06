variable "app_name" {
  description = "Base name used to build the primary and replica bucket names"
  type        = string
}

variable "environment" {
  description = "Environment label used for tagging"
  type        = string
  default     = "lab"
}
