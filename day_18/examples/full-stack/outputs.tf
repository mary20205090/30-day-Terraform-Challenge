output "alb_dns_name" {
  description = "ALB DNS name returned by the end-to-end stack"
  value       = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  description = "ASG name returned by the end-to-end stack"
  value       = module.webserver_cluster.asg_name
}

output "vpc_id" {
  description = "VPC ID returned by the end-to-end stack"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs returned by the end-to-end stack"
  value       = module.vpc.public_subnet_ids
}
