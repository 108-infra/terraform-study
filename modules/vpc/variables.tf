variable "env" {
  description = "環境名"
  type        = string
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
}

variable "azs" {
  description = "使用するAZのリスト（ALBのため最低2つ必要）"
  type        = list(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "private_subnet_cidr" {
  description = "プライベートサブネットのCIDR"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "パブリックサブネットのCIDRリスト"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "enable_ssm_endpoints" {
  description = "EC2をSSM(Session Manager)で管理するためのVPCエンドポイント(ssm/ssmmessages/ec2messages)を作成するか"
  type        = bool
  default     = false
}

variable "enable_ecs_endpoints" {
  description = "ECS FargateがNAT無しでECR pull/CloudWatch Logs/ECS Execを行うためのVPCエンドポイント(ecr.api/ecr.dkr/logs/s3/ssmmessages)を作成するか"
  type        = bool
  default     = false
}
