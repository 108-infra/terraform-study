################################################################################
# VPC Flow Logs 用変数
# 既存の modules/vpc/variables.tf にこの内容を追記してください
################################################################################

variable "enable_flow_logs" {
  description = "VPC Flow Logsを有効にするか"
  type        = bool
  default     = true
}

variable "flow_log_traffic_type" {
  description = "Flow Logsのトラフィックタイプ (ALL / ACCEPT / REJECT)"
  type        = string
  default     = "ALL"

  validation {
    condition     = contains(["ALL", "ACCEPT", "REJECT"], var.flow_log_traffic_type)
    error_message = "flow_log_traffic_type は ALL, ACCEPT, REJECT のいずれかを指定してください。"
  }
}

variable "flow_log_retention_days" {
  description = "CloudWatch Logsの保持日数"
  type        = number
  default     = 30
}
