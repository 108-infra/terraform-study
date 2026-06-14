################################################################################
# VPC Flow Logs
# ネットワークトラフィックを CloudWatch Logs に記録する
################################################################################
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  count             = var.enable_flow_logs ? 1 : 0
  name              = "/aws/vpc/flow-logs/${var.project_name}-${var.env}"
  retention_in_days = var.flow_log_retention_days

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.env}-vpc-flow-logs"
  })
}

resource "aws_iam_role" "vpc_flow_log" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "${var.project_name}-${var.env}-vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "vpc_flow_log" {
  count = var.enable_flow_logs ? 1 : 0
  name  = "${var.project_name}-${var.env}-vpc-flow-log-policy"
  role  = aws_iam_role.vpc_flow_log[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = aws_cloudwatch_log_group.vpc_flow_log[0].arn
      }
    ]
  })
}

resource "aws_flow_log" "vpc" {
  count           = var.enable_flow_logs ? 1 : 0
  vpc_id          = aws_vpc.main.id
  traffic_type    = var.flow_log_traffic_type
  iam_role_arn    = aws_iam_role.vpc_flow_log[0].arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log[0].arn

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.env}-flow-log"
  })
}
