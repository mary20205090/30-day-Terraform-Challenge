output "alb_dns_name" {
  value       = aws_lb.web.dns_name
  description = "DNS name of the Application Load Balancer."
}

output "target_group_arn" {
  value       = aws_lb_target_group.web.arn
  description = "ARN of the ALB target group, consumed by the ASG module."
}

output "target_group_arn_suffix" {
  value       = aws_lb_target_group.web.arn_suffix
  description = "Target group ARN suffix for CloudWatch metrics."
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "Security group ID of the ALB."
}

output "high_request_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.high_request_count.alarm_name
  description = "Name of the ALB high request count alarm."
}
