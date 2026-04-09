output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "instance_security_group_id" {
  description = "Security group attached to the ASG instances"
  value       = aws_security_group.instance.id
}

output "alerts_topic_arn" {
  description = "SNS topic ARN used for ASG alerts"
  value       = aws_sns_topic.alerts.arn
}
