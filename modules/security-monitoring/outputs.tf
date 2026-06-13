output "sns_topic_arn" {
  description = "セキュリティアラート SNS Topic の ARN"
  value       = aws_sns_topic.alerts.arn
}

output "cloudtrail_name" {
  description = "CloudTrail 名"
  value       = aws_cloudtrail.main.name
}

output "cloudwatch_log_group_name" {
  description = "CloudWatch Logs グループ名"
  value       = aws_cloudwatch_log_group.cloudtrail.name
}
