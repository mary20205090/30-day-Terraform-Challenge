variable "environment_name" {
  description = "Name of the environment this folder represents"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "EC2 instance type for the dev environment"
  type        = string
  default     = "t3.micro"
}
