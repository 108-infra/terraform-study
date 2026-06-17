output "security_group_id" {
  description = "ALBのセキュリティグループID"
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "ECSサービスにアタッチするターゲットグループARN"
  value       = aws_lb_target_group.this.arn
}

output "alb_dns_name" {
  description = "ALBのDNS名"
  value       = aws_lb.this.dns_name
}

output "listener_arn" {
  description = "ALBリスナーARN"
  value       = aws_lb_listener.this.arn
}
