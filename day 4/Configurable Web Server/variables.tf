variable "region" {
  description = "AWS region for the configurable web server"
  type        = string
  default     = "us-west-2"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "server_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "configurable-web-server"
}

variable "environment" {
  description = "Environment label applied to resources"
  type        = string
  default     = "dev"
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access the web server"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
