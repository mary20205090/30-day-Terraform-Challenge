output "upper_names" {
  value       = [for name in var.count_user_names : upper(name)]
  description = "Uppercase version of the count user names"
}

output "user_arns" {
  value       = { for name, user in aws_iam_user.foreach_users : name => user.arn }
  description = "Map of user name to ARN for the for_each users"
}
