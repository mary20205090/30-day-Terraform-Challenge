variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "demo_vpc"
}

variable "private_subnets" {
  description = "Private subnet names and subnet indexes"
  type        = map(number)

  default = {
    private_subnet_1 = 0
    private_subnet_2 = 1
  }
}

variable "public_subnets" {
  description = "Public subnet names and subnet indexes"
  type        = map(number)

  default = {
    public_subnet_1 = 2
  }
}
