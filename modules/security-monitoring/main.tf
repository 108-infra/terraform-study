# =============================================================
# Security Monitoring Module - インフラ基盤
# 監視対象:
#   - ルートユーザーログイン
#   - IAMユーザー/ポリシー変更
#   - コンソールログイン失敗
#
# コスト最適化方針:
#   - CloudTrail は CloudWatch Logs へのストリームに特化
#   - S3 は Trail の必須要件のため最小構成で作成し、
#     ライフサイクルルールで1日後に自動削除 → 実質ストレージ費用ゼロ
#   - ログの永続保存は CloudWatch Logs（90日）のみ
# =============================================================

# -------------------------------------------------------------
# CloudTrail
# -------------------------------------------------------------
resource "aws_cloudtrail" "main" {
  name                          = "${var.prefix}-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true # IAM等グローバルサービスを含める
  is_multi_region_trail         = true # 全リージョンのイベントを収集
  enable_log_file_validation    = true
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail_cw.arn

  # S3バケットポリシーが適用されてからTrailを作成する
  depends_on = [aws_s3_bucket_policy.cloudtrail]

  tags = var.tags
}

# -------------------------------------------------------------
# CloudTrail 用 S3 バケット（最小構成・実質コストゼロ）
#
# CloudTrail の API 仕様上 S3 バケット指定が必須のため作成するが、
# ライフサイクルルールで翌日に全オブジェクトを自動削除する。
# ログの実体は CloudWatch Logs に保存されるためデータ損失なし。
# -------------------------------------------------------------
resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.prefix}-cloudtrail-logs-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = var.tags
}

# 1日後にオブジェクトを自動削除 → S3ストレージ費用をほぼゼロに
resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    id     = "auto-delete-cloudtrail-logs"
    status = "Enabled"

    filter {} # 全オブジェクトに適用

    expiration {
      days = 1
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id
  policy = data.aws_iam_policy_document.cloudtrail_s3.json
}

data "aws_iam_policy_document" "cloudtrail_s3" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.cloudtrail.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.cloudtrail.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# -------------------------------------------------------------
# CloudWatch Logs グループ（CloudTrail → CWL）
# -------------------------------------------------------------
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/${var.prefix}"
  retention_in_days = var.log_retention_days

  tags = var.tags
}

# -------------------------------------------------------------
# CloudTrail → CloudWatch Logs 書き込み用 IAM ロール
# -------------------------------------------------------------
resource "aws_iam_role" "cloudtrail_cw" {
  name = "${var.prefix}-cloudtrail-cw-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "cloudtrail.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "cloudtrail_cw" {
  name = "${var.prefix}-cloudtrail-cw-policy"
  role = aws_iam_role.cloudtrail_cw.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
    }]
  })
}

# -------------------------------------------------------------
# SNS Topic（通知先）
# -------------------------------------------------------------
resource "aws_sns_topic" "alerts" {
  name = "${var.prefix}-security-alerts"
  tags = var.tags
}

# メール通知サブスクリプション（email が指定されている場合のみ作成）
resource "aws_sns_topic_subscription" "email" {
  count     = var.alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# -------------------------------------------------------------
# データソース
# -------------------------------------------------------------
data "aws_caller_identity" "current" {}
