output "environment_name" {
  value       = var.environment_name
  description = "The environment managed by this folder"
}

output "instance_id" {
  value       = aws_instance.web.id
  description = "EC2 instance ID for the dev environment"
}

output "vpc_id" {
  value       = data.aws_vpc.default.id
  description = "VPC ID exposed for other configurations to reuse"
}

output "subnet_id" {
  value       = data.aws_subnets.default.ids[0]
  description = "Subnet ID exposed for other configurations to reuse"
}
