output "alb_dns_name" {
  description = "DNS name of the ALB created by the dev environment"
  value       = module.hello_world_app.alb_dns_name
}

output "asg_name" {
  description = "Name of the ASG created by the dev environment"
  value       = module.hello_world_app.asg_name
}

output "alerts_topic_arn" {
  description = "SNS topic ARN created for dev alerts"
  value       = module.hello_world_app.alerts_topic_arn
}
