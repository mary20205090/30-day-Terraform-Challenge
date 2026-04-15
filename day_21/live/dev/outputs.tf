output "alb_dns_name" {
  description = "ALB DNS name for the Day 21 infrastructure workflow"
  value       = module.webserver_cluster.alb_dns_name
}

output "asg_name" {
  description = "ASG name for the Day 21 infrastructure workflow"
  value       = module.webserver_cluster.asg_name
}

output "alerts_topic_arn" {
  description = "SNS topic ARN for autoscaling alerts"
  value       = module.webserver_cluster.alerts_topic_arn
}

output "asg_capacity_alarm_name" {
  description = "CloudWatch alarm that watches ASG in-service capacity"
  value       = aws_cloudwatch_metric_alarm.asg_capacity_low.alarm_name
}
