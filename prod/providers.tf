terraform {
  required_version = "~> 1.15"  # 1.15以上2.0未満を許可

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
  profile = "terraform-study"
}