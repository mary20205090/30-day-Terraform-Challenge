output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "alb_http_listener_arn" {
  description = "ARN of the ALB HTTP listener"
  value       = aws_lb_listener.http.arn
}

output "alb_security_group_id" {
  description = "Security group ID attached to the ALB"
  value       = aws_security_group.alb.id
}
