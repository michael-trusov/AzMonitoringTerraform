locals {
    more_details_afd = "https://confluence.corp.ad.ctc/display/APT/Logging+and+Monitoring+of+Azure+Front+Door"
    frontdoor_id = "/subscriptions/42c0910c-ba8d-4218-96f2-e8bbcfdb8dc0/resourceGroups/ctc-nonprod-apim-cc-rg/providers/Microsoft.Network/frontDoors/ctc-nonprod-apim-cc-fd"

    afd_alert_muc1A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "custom-afd-muc1A1"
    metric_namespace = "Microsoft.Network/frontdoors"
    metric_name      = "RequestSize"
    description      = format("%s %s", "Rise an alert when average number of requests with size lower or equal to 1500 bytes during 5 minutes. More details:", local.more_details_afd)
    aggregation      = "Average"
    operator         = "LessThanOrEqual"
    threshold        = 1500
    severity         = 3
    frequency        = "PT1M"
    window_size      = "PT5M"

    dimensions = []

    action_group_name = ""
    action_group_id   = module.main.monitor_action_group_id["platform_team_major_ag"]
  }

  /*
    Alert - MUC2A.1

    Condition:
    If Total Latency is greater than 10 sec during the 5 min rise an alert and send notification to the platform team
  */
  afd_alert_muc2A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "custom-afd-muc2A1"
    metric_namespace = "Microsoft.Network/frontdoors"
    metric_name      = "TotalLatency"
    description      = format("%s %s", "Rise an alert when 'Total Latency' is greater than 10 sec during the 5 min. More details:", local.more_details_afd)
    aggregation      = "Average"
    operator         = "GreaterThanOrEqual"
    threshold        = 10000
    severity         = 3
    frequency        = "PT1M"
    window_size      = "PT5M"

    dimensions = []

    action_group_name = ""
    action_group_id   = module.main.monitor_action_group_id["platform_team_ag"]
  }

  /*
    Alert - MUC2A.2

    Condition:
    If Total Latency is greater than 20 sec during the 5 min rise an alert
  */
  afd_alert_muc2A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "custom-afd-muc2A2"
    metric_namespace = "Microsoft.Network/frontdoors"
    metric_name      = "TotalLatency"
    description      = format("%s %s", "Rise an alert when 'Total Latency' is greater than 20 sec during the 5 min. More details:", local.more_details_afd)
    aggregation      = "Average"
    operator         = "GreaterThanOrEqual"
    threshold        = 20000
    severity         = 2
    frequency        = "PT1M"
    window_size      = "PT5M"

    dimensions = []

    action_group_name = ""
    action_group_id   = module.main.monitor_action_group_id["platform_team_major_ag"]
  }
}