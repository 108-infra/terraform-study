output "cluster_name" {
  description = "ECSクラスタ名"
  value       = aws_ecs_cluster.this.name
}

output "service_name" {
  description = "ECSサービス名"
  value       = aws_ecs_service.this.name
}
