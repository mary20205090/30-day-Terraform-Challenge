output "alb_dns_name" {
  description = "DNS name of the ALB fronting the app"
  value       = module.alb.alb_dns_name
}

output "asg_name" {
  description = "Name of the ASG running the app instances"
  value       = module.asg.asg_name
}

output "instance_security_group_id" {
  description = "Security group ID attached to the app instances"
  value       = module.asg.instance_security_group_id
}

output "alerts_topic_arn" {
  description = "SNS topic ARN used for application alerts"
  value       = module.asg.alerts_topic_arn
}
