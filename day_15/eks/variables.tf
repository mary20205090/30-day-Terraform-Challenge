variable "region" {
  description = "AWS region for the EKS lab"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "terraform-challenge-cluster"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.29"
}

variable "environment" {
  description = "Environment label used for tags"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the learning VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnets used by the cost-aware learning VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS managed node group"
  type        = string
  default     = "t3.small"
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "nginx_replicas" {
  description = "Number of nginx Pods to run in the Kubernetes deployment"
  type        = number
  default     = 2
}
