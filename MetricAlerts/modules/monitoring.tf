module "monitoring" {
  source = "../../../../../Source/eis-terraform-modules/terraform-azurerm-monitor"

  resource_id       = var.api_management.id
  log_analytical_id = var.azurerm_log_analytics_workspace_id

  activity_log_alerts = var.activity_log_alerts
  metric_alerts       = var.metric_alerts
  query_alerts        = var.query_alerts
  action_groups       = var.action_groups
  rule_action_groups  = var.rule_action_groups
}