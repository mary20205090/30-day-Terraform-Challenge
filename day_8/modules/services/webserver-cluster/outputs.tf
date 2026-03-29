output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.example.name
  description = "The name of the Auto Scaling Group"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "The ID of the load balancer security group"
}

output "instance_security_group_id" {
  value       = aws_security_group.instance.id
  description = "The ID of the instance security group"
}

output "target_group_arn" {
  value       = aws_lb_target_group.example.arn
  description = "The ARN of the load balancer target group"
}

output "server_port" {
  value       = var.server_port
  description = "The application port used by the cluster instances"
}
