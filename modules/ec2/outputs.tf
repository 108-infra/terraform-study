output "instance_id" {
  value = aws_instance.web.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

# 追加
output "instance_ids" {
  value = [aws_instance.web.id]
}