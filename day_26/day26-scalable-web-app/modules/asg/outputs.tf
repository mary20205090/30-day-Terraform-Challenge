output "asg_name" {
  value       = aws_autoscaling_group.web.name
  description = "Name of the Auto Scaling Group."
}

output "asg_arn" {
  value       = aws_autoscaling_group.web.arn
  description = "ARN of the Auto Scaling Group."
}

output "scale_out_policy_arn" {
  value       = aws_autoscaling_policy.scale_out.arn
  description = "ARN of the CPU scale-out policy."
}

output "scale_in_policy_arn" {
  value       = aws_autoscaling_policy.scale_in.arn
  description = "ARN of the CPU scale-in policy."
}

output "cpu_high_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.cpu_high.alarm_name
  description = "Name of the CPU high alarm."
}

output "cpu_low_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.cpu_low.alarm_name
  description = "Name of the CPU low alarm."
}

output "dashboard_name" {
  value       = var.enable_dashboard ? aws_cloudwatch_dashboard.web[0].dashboard_name : null
  description = "CloudWatch dashboard name."
}
