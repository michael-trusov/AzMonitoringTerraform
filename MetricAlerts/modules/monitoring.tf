module "monitoring" {
  source = "../../../eis-terraform-modules/terraform-azurerm-monitor"

  resource_id       = var.api_management.id
  log_analytical_id = var.azurerm_log_analytics_workspace_id

  action_groups       = var.action_groups 
  activity_log_alerts = var.activity_log_alerts
  metric_alerts       = var.metric_alerts
  query_alerts        = var.query_alerts
  rule_action_groups  = var.rule_action_groups
}