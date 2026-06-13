output "vpc_id" {
  value = aws_vpc.main.id
}

# public が count になったので [0] を追記
output "subnet_id" {
  value = aws_subnet.public[0].id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}

# ALBモジュールに渡すリストを追加
output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}