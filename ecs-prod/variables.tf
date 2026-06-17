# prod/variables.tf
variable "env" {
  description = "環境名"
  type        = string
}

variable "region" {
  description = "AWSリージョン"
  type        = string
}

variable "vpc_cidr" {
  description = "VPCのCIDRブロック"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "パブリックサブネットのCIDRリスト"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "プライベートサブネットのCIDR"
  type        = string
}

variable "azs" {
  description = "使用するAZのリスト"
  type        = list(string)
}

variable "project_name" {
  description = "プロジェクト名"
  type        = string
}

variable "aws_profile" {
  description = "AWS CLIプロファイル名"
  type        = string
  default     = "terraform-study"
}
