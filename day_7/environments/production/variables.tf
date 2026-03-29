variable "environment_name" {
  description = "Name of the environment this folder represents"
  type        = string
  default     = "production"
}

variable "instance_type" {
  description = "EC2 instance type for the production environment"
  type        = string
  default     = "t3.micro"
}
