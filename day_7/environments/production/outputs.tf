output "environment_name" {
  value       = var.environment_name
  description = "The environment managed by this folder"
}

output "instance_id" {
  value       = aws_instance.web.id
  description = "EC2 instance ID for the production environment"
}

output "source_vpc_id" {
  value       = try(data.terraform_remote_state.dev_network.outputs.vpc_id, null)
  description = "VPC ID read from the dev remote state"
}

output "source_subnet_id" {
  value       = try(data.terraform_remote_state.dev_network.outputs.subnet_id, null)
  description = "Subnet ID read from the dev remote state"
}
