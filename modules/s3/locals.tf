locals {
  bucket_name = "terraform-study-${var.env}"
  common_tags = {
    Env     = var.env
    Project = "terraform-study"
  }
}