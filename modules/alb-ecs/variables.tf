variable "env" {
  description = "環境名"
  type        = string
}

variable "name" {
  description = "ALBの名前プレフィックス"
  type        = string
}

variable "vpc_id" {
  description = "VPCのID"
  type        = string
}

variable "public_subnet_ids" {
  description = "ALBを配置するパブリックサブネットIDのリスト"
  type        = list(string)
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}
