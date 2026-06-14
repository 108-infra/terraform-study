output "s3_bucket_name" {
  description = "tfstate保存用S3バケット名"
  value       = aws_s3_bucket.tfstate.bucket
}

output "dynamodb_table_name" {
  description = "State Lock用DynamoDBテーブル名"
  value       = aws_dynamodb_table.tfstate_lock.name
}

output "aws_account_id" {
  description = "AWSアカウントID"
  value       = data.aws_caller_identity.current.account_id
  sensitive   = true
}
