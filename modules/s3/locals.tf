locals {
  bucket_name = "${var.project_name}-${var.env}"
  common_tags = {
    Env     = var.env
    Project = var.project_name
  }
}
