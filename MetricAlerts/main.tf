terraform {
  required_version = ">= 0.13"

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
data "azurerm_api_management" "ctc_test_apim" {
  name                = "ctc-test-apim"
  resource_group_name = "ctc-personal-apim-we-rg"
}

# get reference to instance of Log Analytics
data "azurerm_log_analytics_workspace" "ctc_test_log_analytics_workspace" {
  name                = "ctc-test-log-analytics-workspace"
  resource_group_name = "ctc-personal-apim-we-rg"
}

data "azurerm_storage_account" "ctc_test_sa" {
  name                = "ctctestsa"
  resource_group_name = "ctc-personal-apim-we-rg"
}

module "main" {
  source = "./modules"

  api_management = data.azurerm_api_management.ctc_test_apim

  azurerm_log_analytics_workspace_id = data.azurerm_log_analytics_workspace.ctc_test_log_analytics_workspace.id

  activity_log_alerts = {
    serviceIssueAlert = local.serviceIssueAlert,
    serviceIssueAlertForSA = local.serviceIssueAlertForSA
  }

  action_groups = {
    platform_team_ag              = local.platform_team_ag,
    platform_team_pre_analysis_ag = local.platform_team_pre_analysis_ag,
    platform_team_major_ag        = local.platform_team_major_ag,
    platform_team_critical_ag     = local.platform_team_critical_ag
  }

  query_alerts = {
    alert_muc1A1 = local.alert_muc1A1,
    alert_muc1A2 = local.alert_muc1A2,
    alert_muc1A3 = local.alert_muc1A3,
    alert_muc1A4 = local.alert_muc1A4,
    alert_muc2A1 = local.alert_muc2A1,
    alert_muc2A2 = local.alert_muc2A2,
    alert_muc2A3 = local.alert_muc2A3,
    alert_muc2A4 = local.alert_muc2A4,
    alert_muc2A5 = local.alert_muc2A5,
    alert_muc2A6 = local.alert_muc2A6,
    alert_muc3A1 = local.alert_muc3A1,
    alert_muc3A2 = local.alert_muc3A2,
    alert_muc4A1 = local.alert_muc4A1,
    alert_muc4A2 = local.alert_muc4A2,
    alert_muc5A1 = local.alert_muc5A1,
    alert_muc5A2 = local.alert_muc5A2,
    alert_muc6A1 = local.alert_muc6A1,
    alert_muc6A2 = local.alert_muc6A2,
    alert_muc7A1 = local.alert_muc7A1,
    alert_muc7A2 = local.alert_muc7A2,
    alert_muc8A1 = local.alert_muc8A1,
    alert_muc8A2 = local.alert_muc8A2
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