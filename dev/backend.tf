# Remote State Backend (dev)
# 本番運用時はコメントアウトを解除してbootstrapを先にapplyする
#
# terraform {
#   backend "s3" {
#     key            = "dev/terraform.tfstate"
#     region         = "ap-northeast-1"
#     encrypt        = true
#     use_lockfile   = true
#   }
# }
