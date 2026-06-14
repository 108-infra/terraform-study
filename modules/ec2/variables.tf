variable "env" {
  description = "環境名"
  type        = string
}

variable "subnet_id" {
  description = "サブネットID"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb_security_group_id" {
  description = "ALBのセキュリティグループID（EC2へのアクセスをALBに限定するため）"
  type        = string
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}
