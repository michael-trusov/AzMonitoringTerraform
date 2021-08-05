locals {
    serviceIssueAlert = {
        alert_name    = "sha-test"
        environment   = var.environment
        location_code = var.location_code
        location      = var.location
        project_name  = var.project_name

        resource_group_name = "ctc-personal-apim-we-rg"
        scopes              = [data.azurerm_api_management.ctc_test_apim.id]
        description         = "This ServiceIssue alert will monitor a Api Management service"
        category            = "ServiceHealth"    

        service_health = [
            {                        
                events   = ["Incident"]
                locations = ["West Europe"]                
            }
        ]

        action_group_name = ""
        action_group_id   = tostring(module.main.monitor_action_group_id["platform_team_ag"])
  }

  serviceIssueAlertForSA = {
        alert_name    = "sha-test-sa"
        environment   = var.environment
        location_code = var.location_code
        location      = var.location
        project_name  = var.project_name

        resource_group_name = "ctc-personal-apim-we-rg"
        scopes              = [data.azurerm_storage_account.ctc_test_sa.id]
        description         = "This ServiceIssue alert will monitor a Storage account service"
        category            = "ServiceHealth"    

        service_health = [
            {                        
                events   = ["Incident"]
                locations = ["West Europe"]                
            }
        ]

        action_group_name = ""
        action_group_id   = tostring(module.main.monitor_action_group_id["platform_team_ag"])
  }
}