# =============================================================
# 監視ルール（メトリクスフィルター + CloudWatch アラーム）
# =============================================================

# -------------------------------------------------------------
# 監視ルール 1: ルートユーザーログイン
# -------------------------------------------------------------
resource "aws_cloudwatch_log_metric_filter" "root_login" {
  name           = "${var.prefix}-root-login"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ $.userIdentity.type = \"Root\" && $.eventName = \"ConsoleLogin\" }"

  metric_transformation {
    name      = "RootLoginCount"
    namespace = "${var.prefix}/SecurityEvents"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_login" {
  alarm_name          = "${var.prefix}-root-login-detected"
  alarm_description   = "ルートユーザーによるコンソールログインを検知しました"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "RootLoginCount"
  namespace           = "${var.prefix}/SecurityEvents"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  tags = var.tags
}

# -------------------------------------------------------------
# 監視ルール 2: IAM ユーザー/ポリシー変更
# -------------------------------------------------------------
resource "aws_cloudwatch_log_metric_filter" "iam_changes" {
  name           = "${var.prefix}-iam-changes"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  # IAM の変更系 API（ポリシー・ユーザー・ロール・グループ・MFA）を一括検知
  pattern = "{($.eventName=DeleteGroupPolicy)||($.eventName=DeleteRolePolicy)||($.eventName=DeleteUserPolicy)||($.eventName=PutGroupPolicy)||($.eventName=PutRolePolicy)||($.eventName=PutUserPolicy)||($.eventName=CreatePolicy)||($.eventName=DeletePolicy)||($.eventName=CreatePolicyVersion)||($.eventName=DeletePolicyVersion)||($.eventName=SetDefaultPolicyVersion)||($.eventName=AttachRolePolicy)||($.eventName=DetachRolePolicy)||($.eventName=AttachUserPolicy)||($.eventName=DetachUserPolicy)||($.eventName=AttachGroupPolicy)||($.eventName=DetachGroupPolicy)||($.eventName=CreateUser)||($.eventName=DeleteUser)||($.eventName=CreateRole)||($.eventName=DeleteRole)||($.eventName=CreateGroup)||($.eventName=DeleteGroup)||($.eventName=CreateVirtualMFADevice)||($.eventName=DeleteVirtualMFADevice)||($.eventName=EnableMFADevice)||($.eventName=DeactivateMFADevice)}"

  metric_transformation {
    name      = "IAMChangesCount"
    namespace = "${var.prefix}/SecurityEvents"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "iam_changes" {
  alarm_name          = "${var.prefix}-iam-changes-detected"
  alarm_description   = "IAMユーザー/ポリシーの変更操作を検知しました"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "IAMChangesCount"
  namespace           = "${var.prefix}/SecurityEvents"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  tags = var.tags
}

# -------------------------------------------------------------
# 監視ルール 3: コンソールログイン失敗
# -------------------------------------------------------------
resource "aws_cloudwatch_log_metric_filter" "login_failure" {
  name           = "${var.prefix}-login-failure"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ $.eventName = \"ConsoleLogin\" && $.errorMessage = \"Failed authentication\" }"

  metric_transformation {
    name      = "ConsoleLoginFailureCount"
    namespace = "${var.prefix}/SecurityEvents"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "login_failure" {
  alarm_name          = "${var.prefix}-login-failure-detected"
  alarm_description   = "コンソールへのログイン失敗を検知しました（5分以内に${var.login_failure_threshold}回以上）"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsoleLoginFailureCount"
  namespace           = "${var.prefix}/SecurityEvents"
  period              = 300
  statistic           = "Sum"
  threshold           = var.login_failure_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = [aws_sns_topic.alerts.arn]

  tags = var.tags
}
