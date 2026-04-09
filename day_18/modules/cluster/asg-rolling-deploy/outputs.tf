output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "instance_security_group_id" {
  description = "Security group attached to the ASG instances"
  value       = aws_security_group.instance.id
}

output "asg_name_prefix" {
  description = "Name prefix used to build the ASG name"
  value       = aws_autoscaling_group.this.name_prefix
}

output "launch_template_instance_type" {
  description = "Instance type configured in the launch template"
  value       = aws_launch_template.this.instance_type
}

output "instance_ingress_port" {
  description = "Ingress port opened from the ALB to the instances"
  value       = aws_vpc_security_group_ingress_rule.app_from_alb.from_port
}

output "alerts_topic_arn" {
  description = "SNS topic ARN used for ASG alerts"
  value       = aws_sns_topic.alerts.arn
}
