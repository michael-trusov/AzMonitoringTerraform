locals {
  apim_id = data.azurerm_api_management.ctc_test_apim.id

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

    azure_function_receiver = []

    webhook_receiver = [
      {
        name                    = "tests-aggregator-api"
        service_uri             = "https://ctc-test-client-ghv-app.azurewebsites.net/api/tests/callback/alert",
        use_common_alert_schema = true
      }
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
        name                     = "mocked-notification-reciever"
        function_app_resource_id = "/subscriptions/470efd2f-74d7-4a6b-b5d8-a811f6c874e6/resourcegroups/ctc-personal-apim-we-rg/providers/Microsoft.Web/sites/ctc-personal-test-api"
        function_name            = "mocked_notification_reciever"
        http_trigger_url         = "https://ctc-personal-test-api.azurewebsites.net/api/mocked_notification_reciever"
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
        name                     = "mocked-notification-reciever"
        function_app_resource_id = "/subscriptions/470efd2f-74d7-4a6b-b5d8-a811f6c874e6/resourcegroups/ctc-personal-apim-we-rg/providers/Microsoft.Web/sites/ctc-personal-test-api"
        function_name            = "mocked_notification_reciever"
        http_trigger_url         = "https://ctc-personal-test-api.azurewebsites.net/api/mocked_notification_reciever"
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
        name                     = "mocked-notification-reciever"
        function_app_resource_id = "/subscriptions/470efd2f-74d7-4a6b-b5d8-a811f6c874e6/resourcegroups/ctc-personal-apim-we-rg/providers/Microsoft.Web/sites/ctc-personal-test-api"
        function_name            = "mocked_notification_reciever"
        http_trigger_url         = "https://ctc-personal-test-api.azurewebsites.net/api/mocked_notification_reciever"
        use_common_alert_schema  = true
      }
    ]

    webhook_receiver = []
  }
}