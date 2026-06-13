variable "env" {
  description = "環境名"
  type        = string
}

variable "region" {
  description = "AWSリージョン"
  type        = string
}

variable "profile" {
  description = "AWS CLI の SSO プロファイル名"
  type        = string
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "alert_email" {
  description = "アラート通知先メールアドレス（空文字で無効）"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch Logs の保存期間（日）"
  type        = number
}

variable "login_failure_threshold" {
  description = "ログイン失敗アラートの閾値（5分以内）"
  type        = number
}
