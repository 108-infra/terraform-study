variable "repository_name" {
  description = "ECRリポジトリ名"
  type        = string
}

variable "tags" {
  description = "タグ"
  type        = map(string)
  default     = {}
}
