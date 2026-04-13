output "alb_dns_name" {
  description = "ALB DNS name for the Day 20 workflow simulation"
  value       = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  description = "ASG name for the Day 20 workflow simulation"
  value       = module.webserver_cluster.asg_name
}

output "alerts_topic_arn" {
  description = "SNS topic ARN for autoscaling alerts"
  value       = module.webserver_cluster.alerts_topic_arn
}
