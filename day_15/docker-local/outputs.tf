output "nginx_url" {
  description = "Local URL where the containerized nginx app should be reachable"
  value       = "http://localhost:${var.external_port}"
}

output "container_name" {
  description = "Name of the Docker container created by Terraform"
  value       = docker_container.nginx.name
}
