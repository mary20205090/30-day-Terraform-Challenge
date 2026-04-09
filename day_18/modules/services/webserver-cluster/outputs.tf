output "alb_dns_name" {
  description = "DNS name of the ALB fronting the webserver cluster"
  value       = module.alb.alb_dns_name
}

output "asg_name" {
  description = "Name of the ASG running the webserver instances"
  value       = module.asg.asg_name
}

output "instance_security_group_id" {
  description = "Security group ID attached to the webserver instances"
  value       = module.asg.instance_security_group_id
}

output "asg_name_prefix" {
  description = "Name prefix used to build the webserver ASG"
  value       = module.asg.asg_name_prefix
}

output "launch_template_instance_type" {
  description = "Instance type configured for the webserver launch template"
  value       = module.asg.launch_template_instance_type
}

output "instance_ingress_port" {
  description = "Ingress port opened from the ALB to the webserver instances"
  value       = module.asg.instance_ingress_port
}

output "alerts_topic_arn" {
  description = "SNS topic ARN used for application alerts"
  value       = module.asg.alerts_topic_arn
}
