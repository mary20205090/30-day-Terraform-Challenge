output "environment_name" {
  value       = var.environment_name
  description = "The environment managed by this folder"
}

output "instance_id" {
  value       = aws_instance.web.id
  description = "EC2 instance ID for the staging environment"
}
