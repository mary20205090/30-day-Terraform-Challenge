# Use these outputs during testing so you know which endpoint to curl.
output "rolling_alb_dns_name" {
  description = "ALB DNS name for the rolling zero-downtime demo on port 80"
  value       = aws_lb.demo.dns_name
}

output "blue_green_url" {
  description = "Blue/green demo URL on port 8080"
  value       = "http://${aws_lb.demo.dns_name}:8080"
}

output "active_environment" {
  description = "Currently active blue/green environment"
  value       = var.active_environment
}

output "rolling_asg_name" {
  description = "Rolling deployment ASG name"
  value       = aws_autoscaling_group.rolling.name
}
