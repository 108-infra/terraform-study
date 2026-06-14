variable "env" {
  description = "環境名"
  type        = string
}

variable "region" {
  description = "AWSリージョン"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLIプロファイル名"
  type        = string
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "alert_email" {
  description = "アラート送信先メールアドレス（空文字で無効）"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch Logsの保持期間（日）"
  type        = number
}

variable "login_failure_threshold" {
  description = "ログイン失敗アラートの閾値（回/時間内）"
  type        = number
}
