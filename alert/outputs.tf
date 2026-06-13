# =============================================================
# Outputs（terraform apply 後に表示される情報）
# =============================================================

output "sns_topic_arn" {
  description = "通知先 SNS Topic ARN（Slack / Lambda 等を後から追加可能）"
  value       = module.security_monitoring.sns_topic_arn
}

output "cloudtrail_name" {
  description = "作成された CloudTrail 名"
  value       = module.security_monitoring.cloudtrail_name
}

output "cloudwatch_log_group_name" {
  description = "CloudTrail ログの参照先（CloudWatch Logs グループ名）"
  value       = module.security_monitoring.cloudwatch_log_group_name
}

output "next_steps" {
  description = "apply 後の確認事項"
  value       = <<-EOT

    ✅ セキュリティ監視の構築が完了しました

    【メール通知を設定した場合】
    AWS から確認メールが届くので「Confirm subscription」をクリックしてください

    【Slack 通知を追加したい場合】
    sns_topic_arn を使って以下を追加できます:
      - AWS Chatbot（推奨・設定が簡単）
      - Lambda + Slack Webhook

    【動作確認】
    CloudWatch > ロググループ > ${module.security_monitoring.cloudwatch_log_group_name}
    にログが流れてくるか確認してください

  EOT
}
