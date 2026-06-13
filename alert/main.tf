module "security_monitoring" {
  source = "../modules/security-monitoring"

  prefix                  = "${var.project_name}-${var.env}"
  alert_email             = var.alert_email
  log_retention_days      = var.log_retention_days
  login_failure_threshold = var.login_failure_threshold
  tags                    = local.common_tags
}
