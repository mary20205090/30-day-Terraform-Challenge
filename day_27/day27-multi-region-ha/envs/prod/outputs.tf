output "primary_alb_dns_name" {
  value       = module.alb_primary.alb_dns_name
  description = "Primary region ALB DNS name"
}

output "secondary_alb_dns_name" {
  value       = module.alb_secondary.alb_dns_name
  description = "Secondary region ALB DNS name"
}

output "primary_db_endpoint" {
  value       = module.rds_primary.db_endpoint
  description = "Primary database endpoint"
}

output "replica_db_endpoint" {
  value       = module.rds_replica.db_endpoint
  description = "Replica database endpoint"
}

output "application_url" {
  value       = module.route53.application_url
  description = "Application URL behind Route53 failover"
}
