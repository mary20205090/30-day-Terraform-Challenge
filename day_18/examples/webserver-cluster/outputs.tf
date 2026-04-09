output "alb_dns_name" {
  description = "ALB DNS name returned by the integration harness"
  value       = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  description = "ASG name returned by the integration harness"
  value       = module.webserver_cluster.asg_name
}

output "alerts_topic_arn" {
  description = "SNS topic ARN returned by the integration harness"
  value       = module.webserver_cluster.alerts_topic_arn
}
