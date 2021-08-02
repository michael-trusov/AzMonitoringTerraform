terraform {
  required_version = ">= 0.14"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.57.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# get reference to instance of API management
data "azurerm_api_management" "apim" {
  name                = "sandbox-monitoring-tests-cc-apim"
  resource_group_name = "ctc-sandbox-apidev-cc-rg"
}

# get reference to instance of Log Analytics
data "azurerm_log_analytics_workspace" "logworkspace" {
  name                = "sandbox-monitoring-tests-cc-loganalytics"
  resource_group_name = "ctc-sandbox-apidev-cc-rg"
}

module "main" {
  source = "./modules"

  api_management = data.azurerm_api_management.apim

  azurerm_log_analytics_workspace_id = data.azurerm_log_analytics_workspace.logworkspace.id

  activity_log_alerts = {}

  action_groups = {
    platform_team_ag              = local.platform_team_ag
    //platform_team_pre_analysis_ag = local.platform_team_pre_analysis_ag,
    //platform_team_major_ag        = local.platform_team_major_ag,
    //platform_team_critical_ag     = local.platform_team_critical_ag
  }

  query_alerts = {
    alert_muc1A1 = local.alert_muc1A1,
    alert_muc1A2 = local.alert_muc1A2,
    alert_muc1A3 = local.alert_muc1A3,
    alert_muc1A4 = local.alert_muc1A4,
    alert_muc3A1 = local.alert_muc3A1,
    alert_muc3A2 = local.alert_muc3A2
  }

  metric_alerts = {
//    alert_muc3A1  = local.alert_muc3A1,
//    alert_muc3A2  = local.alert_muc3A2
//    alert_muc4A1  = local.alert_muc4A1,
//    alert_muc4A2  = local.alert_muc4A2,
//    alert_muc5A1  = local.alert_muc5A1,
//    alert_muc5A2  = local.alert_muc5A2,
//    alert_muc6A1  = local.alert_muc6A1,
//    alert_muc6A2  = local.alert_muc6A2,
//    alert_muc7A1  = local.alert_muc7A1,
//    alert_muc7A2  = local.alert_muc7A2,
//    alert_muc8A1  = local.alert_muc8A1,
//    alert_muc8A2  = local.alert_muc8A2,
//    alert_muc9A1  = local.alert_muc9A1,
//    alert_muc9A2  = local.alert_muc9A2,
//    alert_muc10A1 = local.alert_muc10A1,
//    alert_muc10A2 = local.alert_muc10A2
  }

  rule_action_groups = {}
}