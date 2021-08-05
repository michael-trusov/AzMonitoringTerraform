locals {
  apim_id = data.azurerm_api_management.apim.id

  platform_team_ag = {
    project_name  = var.project_name
    environment   = var.environment
    location_code = var.location_code
    group_name    = "platform_team_ag"
    short_name    = "ptfTeamAg"
    type          = "Resource"

    email_receiver = [
      {
        name          = "Platform Team"
        email_address = "Mykhaylo_Trusov@epam.com"
      }
    ]

    sms_receiver = []

    voice_receiver = []

    azure_function_receiver = [
      {
        name                     = "sandbox-noi-funcapp"
        function_app_resource_id = "/subscriptions/e321efb2-bff7-4ec0-a4a7-c5f95abef641/resourcegroups/ctc-sandbox-apidev-cc-rg/providers/Microsoft.Web/sites/sandbox-noi-funcapp"
        function_name            = "apim-noi-notification"
        http_trigger_url         = "https://sandbox-noi-funcapp.azurewebsites.net/api/apim-noi-notification"
        use_common_alert_schema  = true
      }
    ]

    webhook_receiver = [      
    ]
  }

  # This group should be used for alerts required additional analyses inside related Azure function
  # Note: Azure function will be specified later, for now, just email notifications
  platform_team_pre_analysis_ag = {
    project_name  = var.project_name
    environment   = var.environment
    location_code = var.location_code
    group_name    = "platform_team_pre_analysis_ag"
    short_name    = "ptfPaAg"
    type          = "Resource"

    email_receiver = [
      {
        name          = "Platform Team (pre-analyses)"
        email_address = "Mykhaylo_Trusov@epam.com"
      }
    ]

    sms_receiver = []

    voice_receiver = []

    azure_function_receiver = [
      {
        name                     = "sandbox-noi-funcapp"
        function_app_resource_id = "/subscriptions/e321efb2-bff7-4ec0-a4a7-c5f95abef641/resourcegroups/ctc-sandbox-apidev-cc-rg/providers/Microsoft.Web/sites/sandbox-noi-funcapp"
        function_name            = "apim-log-alert-analyzer"
        http_trigger_url         = "https://sandbox-noi-funcapp.azurewebsites.net/api/apim-log-alert-analyzer"
        use_common_alert_schema  = true
      }
    ]

    webhook_receiver = []
  }


  # This group will be extended with SMS notifications later
  platform_team_major_ag = {
    project_name  = var.project_name
    environment   = var.environment
    location_code = var.location_code
    group_name    = "platform_team_major_ag"
    short_name    = "pfTeamMjAg"
    type          = "Resource"

    email_receiver = [
      {
        name          = "Platform Team - Major"
        email_address = "Mykhaylo_Trusov@epam.com"
      }
    ]

    sms_receiver = []

    voice_receiver = []

    azure_function_receiver = [
      {
        name                     = "sandbox-noi-funcapp"
        function_app_resource_id = "/subscriptions/e321efb2-bff7-4ec0-a4a7-c5f95abef641/resourcegroups/ctc-sandbox-apidev-cc-rg/providers/Microsoft.Web/sites/sandbox-noi-funcapp"
        function_name            = "apim-noi-notification"
        http_trigger_url         = "https://sandbox-noi-funcapp.azurewebsites.net/api/apim-noi-notification"
        use_common_alert_schema  = true
      }
    ]

    webhook_receiver = []
  }

  # This group will be extended with SMS notifications and voice call later
  platform_team_critical_ag = {
    project_name  = var.project_name
    environment   = var.environment
    location_code = var.location_code
    group_name    = "platform_team_critical_ag"
    short_name    = "pfTeamCrAg"
    type          = "Resource"

    email_receiver = [
      {
        name          = "Platform Team - Critical"
        email_address = "Mykhaylo_Trusov@epam.com"
      }
    ]

    sms_receiver = []

    voice_receiver = []

    azure_function_receiver = [
      {
        name                     = "sandbox-noi-funcapp"
        function_app_resource_id = "/subscriptions/e321efb2-bff7-4ec0-a4a7-c5f95abef641/resourcegroups/ctc-sandbox-apidev-cc-rg/providers/Microsoft.Web/sites/sandbox-noi-funcapp"
        function_name            = "apim-noi-notification"
        http_trigger_url         = "https://sandbox-noi-funcapp.azurewebsites.net/api/apim-noi-notification"
        use_common_alert_schema  = true
      }
    ]

    webhook_receiver = []
  }
}