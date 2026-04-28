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
  value       = var.create_route53_failover ? module.route53[0].application_url : "http://${module.alb_primary.alb_dns_name}"
  description = "Route53 failover URL when enabled, otherwise the primary ALB URL for lab verification"
}

output "route53_failover_enabled" {
  value       = var.create_route53_failover
  description = "Whether Route53 failover records were created for this deployment"
}
