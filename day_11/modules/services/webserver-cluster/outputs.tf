output "environment_summary" {
  description = "Selected environment-driven settings for the module"
  value = {
    environment                 = var.environment
    instance_type               = local.instance_type
    min_cluster_size            = local.min_cluster_size
    max_cluster_size            = local.max_cluster_size
    detailed_monitoring_enabled = local.detailed_monitoring_enabled
    dns_record_enabled          = local.dns_record_enabled
    use_existing_vpc            = var.use_existing_vpc
  }
}

output "vpc_id" {
  description = "VPC selected by the conditional VPC logic"
  value       = local.vpc_id
}

output "instance_id" {
  description = "The EC2 instance ID for the Day 11 webserver"
  value       = aws_instance.web.id
}

output "alarm_arn" {
  description = "The CloudWatch alarm ARN when detailed monitoring is enabled"
  value       = local.detailed_monitoring_enabled ? aws_cloudwatch_metric_alarm.high_cpu[0].arn : null
}

output "dns_record_fqdn" {
  description = "The Route53 DNS record when DNS creation is enabled"
  value       = local.dns_record_enabled ? aws_route53_record.web[0].fqdn : null
}
