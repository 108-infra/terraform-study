terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#--------------------------------------------------------------
# IAMロール（SSM用）
#--------------------------------------------------------------
resource "aws_iam_role" "web" {
  name = "ec2-web-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.web.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "web" {
  name = "ec2-web-profile-${var.env}"
  role = aws_iam_role.web.name
}

#--------------------------------------------------------------
# セキュリティグループ
#--------------------------------------------------------------
resource "aws_security_group" "web" {
  name        = "web-sg-${var.env}"
  description = "Allow HTTP only from ALB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "HTTP from ALB only"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "web-sg-${var.env}"
  })
}

#--------------------------------------------------------------
# EC2インスタンス
#--------------------------------------------------------------
resource "aws_instance" "web" {
  ami                         = "ami-0599b6e53ca798bb2"
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.web.name

  tags = merge(local.common_tags, {
    Name = "web-server-${var.env}"
  })
}
