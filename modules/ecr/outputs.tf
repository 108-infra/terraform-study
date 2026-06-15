output "repository_url" {
  description = "ECRリポジトリのURL"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_name" {
  description = "ECRリポジトリ名"
  value       = aws_ecr_repository.this.name
}
