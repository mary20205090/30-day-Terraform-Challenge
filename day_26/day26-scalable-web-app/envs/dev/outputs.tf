output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the Application Load Balancer."
}

output "alb_url" {
  value       = "http://${module.alb.alb_dns_name}"
  description = "HTTP URL for the load-balanced web application."
}

output "target_group_arn" {
  value       = module.alb.target_group_arn
  description = "Target group ARN used to verify registered ASG targets."
}

output "asg_name" {
  value       = module.asg.asg_name
  description = "Name of the Auto Scaling Group."
}

output "cpu_high_alarm_name" {
  value       = module.asg.cpu_high_alarm_name
  description = "Name of the scale-out CPU alarm."
}

output "cpu_low_alarm_name" {
  value       = module.asg.cpu_low_alarm_name
  description = "Name of the scale-in CPU alarm."
}

output "high_request_alarm_name" {
  value       = module.alb.high_request_alarm_name
  description = "Name of the ALB high request count alarm."
}

output "dashboard_name" {
  value       = module.asg.dashboard_name
  description = "CloudWatch dashboard name."
}

output "selected_vpc_id" {
  value       = local.effective_vpc_id
  description = "VPC used by the dev environment."
}

output "selected_subnet_ids" {
  value       = local.effective_public_subnet_ids
  description = "Subnets selected for this lab."
}
