variable "project_name" {
  description = "プロジェクト名（S3バケット名に使用）"
  type        = string
  default     = "terraform-study"
}

variable "aws_region" {
  description = "AWSリージョン"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS CLIプロファイル名"
  type        = string
  default     = "terraform-study"
}
