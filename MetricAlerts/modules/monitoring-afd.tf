module "monitoring-afd" {
  source  = "../../../eis-terraform-modules/terraform-azurerm-monitor"  

  resource_id         = var.monitoring_frontdoor_id
  log_analytical_id   = var.azurerm_log_analytics_workspace_id
  activity_log_alerts = {}
  metric_alerts       = {}//var.frontdoor_metric_alerts
  query_alerts        = {}
  action_groups       = {}
  rule_action_groups  = {}
}
