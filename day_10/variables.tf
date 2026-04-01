variable "region" {
  description = "AWS region for the Day 10 loop and conditional demos"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name used for conditional sizing"
  type        = string
  default     = "dev"
}

variable "ami_name_pattern" {
  description = "AMI name pattern used to locate a recent Ubuntu image"
  type        = string
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "ami_owner" {
  description = "AWS account ID that owns the Ubuntu AMI"
  type        = string
  default     = "099720109477"
}

# Count demo inputs
variable "enable_count_demo" {
  description = "Set to true to create IAM users with count"
  type        = bool
  default     = false
}

variable "count_user_names" {
  description = "List of IAM users for the count demo (order matters)"
  type        = list(string)
  # default     = ["alice", "bob", "charlie"]
  default = ["bob", "charlie"]

}

# for_each demo inputs
variable "enable_foreach_demo" {
  description = "Set to true to create IAM users with for_each"
  type        = bool
  default     = false
}

variable "foreach_user_names" {
  description = "Set of IAM users for the for_each demo"
  type        = set(string)
  default     = ["alice", "bob", "charlie"]
}

variable "enable_foreach_tags_demo" {
  description = "Set to true to create IAM users with per-user tag data"
  type        = bool
  default     = false
}

variable "users" {
  description = "Map of IAM users with extra per-user configuration"
  type = map(object({
    department = string
    admin      = bool
  }))
  default = {
    alice = { department = "engineering", admin = true }
    bob   = { department = "marketing", admin = false }
  }
}

# Conditional instance demo
variable "enable_conditional_instance" {
  description = "Set to true to create the conditional instance example"
  type        = bool
  default     = false
}
