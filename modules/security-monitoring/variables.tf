variable "prefix" {
  description = "リソース名のプレフィックス（例: myname-dev）"
  type        = string
}

variable "alert_email" {
  description = "アラート通知先メールアドレス（空文字の場合は作成しない）"
  type        = string
  default     = ""
}

variable "log_retention_days" {
  description = "CloudWatch Logs の保存期間（日）。5GB/月まで無料枠あり。個人利用なら90日で十分"
  type        = number
  default     = 90
}

variable "login_failure_threshold" {
  description = "ログイン失敗のアラート閾値（5分以内のカウント）"
  type        = number
  default     = 3
}

variable "tags" {
  description = "各リソースに付与する共通タグ"
  type        = map(string)
  default     = {}
}
