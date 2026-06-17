variable "env" {
  description = "環境名"
  type        = string
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "subnet_id" {
  description = "ECSタスクを配置するサブネットID（プライベートサブネット推奨）"
  type        = string
}

variable "alb_security_group_id" {
  description = "ALBのセキュリティグループID"
  type        = string
}

variable "target_group_arn" {
  description = "ALBのターゲットグループARN"
  type        = string
}

variable "container_image" {
  description = "ECRのイメージURI（タグ込み）"
  type        = string
}

variable "region" {
  description = "AWSリージョン"
  type        = string
}

variable "task_cpu" {
  description = "タスクのCPUユニット"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "タスクのメモリ（MB）"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "起動するタスク数"
  type        = number
  default     = 1
}
