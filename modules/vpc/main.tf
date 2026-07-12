terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true # Interface Endpoint の Private DNS 解決に必要

  tags = merge(local.common_tags, {
    Name = "vpc-${var.env}"
  })
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index] # ← 変数化
  availability_zone = var.azs[count.index]                 # ← 変数化

  tags = merge(local.common_tags, {
    Name = "subnet-public-${var.azs[count.index]}-${var.env}"
  })
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr # ← 変数化
  availability_zone = var.azs[0]              # ← 変数化

  tags = merge(local.common_tags, {
    Name = "subnet-private-${var.env}"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.common_tags, {
    Name = "igw-${var.env}"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(local.common_tags, {
    Name = "rt-public-${var.env}"
  })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public) # ← countに対応
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}