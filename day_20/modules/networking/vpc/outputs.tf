output "vpc_id" {
  description = "ID of the VPC created for end-to-end tests"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs used by the webserver cluster"
  value       = aws_subnet.public[*].id
}
