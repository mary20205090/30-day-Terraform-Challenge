output "db_endpoint" {
  description = "Database endpoint for application connectivity"
  value       = aws_db_instance.example.endpoint
}

# Mark the connection string as sensitive so Terraform hides it in CLI output.
output "db_connection_string" {
  description = "Connection string for the database"
  value       = "mysql://${aws_db_instance.example.username}@${aws_db_instance.example.endpoint}/${var.db_name}"
  sensitive   = true
}

output "db_secret_name" {
  description = "Secrets Manager secret used by this lab"
  value       = data.aws_secretsmanager_secret.db_credentials.name
}
