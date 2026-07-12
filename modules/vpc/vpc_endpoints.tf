################################################################################
# Private Subnet 用ルートテーブル
# NAT Gatewayを使わない構成のため、明示的にローカルルートのみのテーブルを持たせる
################################################################################
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "rt-private-${var.env}"
  })
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

################################################################################
# VPC Endpoints
# NAT Gatewayを使わず、private subnetからAWSサービスAPIへ到達させるための
# Gateway Endpoint (S3) と Interface Endpoint (ECR/CloudWatch Logs/SSM) を作成する
################################################################################
data "aws_region" "current" {}

locals {
  interface_endpoint_services = toset(concat(
    var.enable_ssm_endpoints ? ["ssm", "ssmmessages", "ec2messages"] : [],
    var.enable_ecs_endpoints ? ["ecr.api", "ecr.dkr", "logs", "ssmmessages"] : []
  ))
}

resource "aws_security_group" "vpc_endpoints" {
  count       = length(local.interface_endpoint_services) > 0 ? 1 : 0
  name        = "${var.project_name}-${var.env}-vpce-sg"
  description = "Allow HTTPS from within the VPC to interface endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTPS from VPC CIDR"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.env}-vpce-sg"
  })
}

# S3 Gateway Endpoint（無料。ECRのイメージレイヤーはS3から配信されるため必要）
resource "aws_vpc_endpoint" "s3" {
  count           = var.enable_ecs_endpoints ? 1 : 0
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids = [aws_route_table.private.id]

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.env}-s3-endpoint"
  })
}

resource "aws_vpc_endpoint" "interface" {
  for_each            = local.interface_endpoint_services
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.private.id]
  security_group_ids  = [aws_security_group.vpc_endpoints[0].id]
  private_dns_enabled = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.env}-${each.value}-endpoint"
  })
}
