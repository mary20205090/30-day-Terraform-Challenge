variable "image_name" {
  description = "Docker image to run locally with Terraform"
  type        = string
  default     = "nginx:latest"
}

variable "container_name" {
  description = "Name for the local Docker container"
  type        = string
  default     = "terraform-nginx"
}

variable "external_port" {
  description = "Port on localhost that should expose the container"
  type        = number
  default     = 8080
}
