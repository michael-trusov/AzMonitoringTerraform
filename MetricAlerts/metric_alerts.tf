locals {
  more_details = "https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert"

  # Alert - MUC4A.1
  #
  # Condition: 
  # If at least 50% of requests receives response with 500 or 400 response code for 15 minutes 
  # then send email notification to platform_team_ag
  #
  # Action group: platform_team_ag
  alert_muc4A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc4A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 50% of requests receives response with 500 or 400 response code for 15 minutes then send email notification to platform_team_ag. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50
    severity         = 3
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("400", "500")
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC4A.2
  #
  # Condition: 
  # If at least 75% of requests receives response with 500 or 400 response code for 15 minutes 
  # then send email notification to platform_team_major_ag and create ticket with severity Critical.
  #
  # Action group: platform_team_major_ag
  alert_muc4A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc4A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 75% of requests receives response with 500 or 400 response code for 15 minutes then send email notification to platform_team_major_ag and create ticket with severity Critical. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 75
    severity         = 2
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("400", "500")
      }
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC5A.1
  #
  # Condition: 
  # If at least 50% of requests receives 403 response code for 15 minutes then send email notification to platform_team_major_ag and
  # create ticket with severity Normal
  #
  # Action group: platform_team_major_ag
  alert_muc5A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc5A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 50% of requests receives 403 response code for 15 minutes then send email notification to platform_team_major_ag and create ticket with severity Normal. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50
    severity         = 3
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("403")
      }
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC5A.2
  #
  # Condition: 
  # If at least 75% of requests receives 403 response code for 15 minutes then send email notification 
  # to platform_team_major_ag and create ticket with severity Critical
  #
  # Action group: platform_team_major_ag
  alert_muc5A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc5A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 75% of requests receives 403 response code for 15 minutes then send email notification to platform_team_major_ag and create ticket with severity Critical. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 75
    severity         = 1
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("403")
      }
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC6A.1
  #
  # Condition: 
  # If at least 50% of requests receives 401 response code for 15 minutes then send email notification to platform_team_ag group 
  # and create ticket with severity Normal
  #
  # Action group: platform_team_ag
  alert_muc6A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc6A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 50% of requests receives 401 response code for 15 minutes then send email notification to platform_team_ag group and create ticket with severity Normal. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50
    severity         = 3
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("401")
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC6A.2
  #
  # Condition: 
  # If at least 75% of requests receives 401 response code for 15 minutes then send email notification to platform_team_ag group and create 
  # ticket with severity Critical
  #
  # Action group: platform_team_ag
  alert_muc6A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc6A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 75% of requests receives 401 response code for 15 minutes then send email notification to platform_team_ag group and create ticket with severity Critical. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 75
    severity         = 1
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("401")
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC7A.1
  #
  # Condition: 
  # If at least 50% of requests receives 404 response code for 15 minutes then 
  # send email notification to platform_team_ag and create ticket with severity Normal
  #
  # Action group: platform_team_major_ag
  alert_muc7A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc7A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 50% of requests receives 404 response code for 15 minutes then send email notification to platform_team_ag and create ticket with severity Normal. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50
    severity         = 3
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("404")
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC7A.2
  #
  # Condition: 
  # If at least 75% of requests receives 404 response code for 15 minutes then 
  # send email notification to platform_team_ag and create ticket with severity Critical
  #
  # Action group: platform_team_ag
  alert_muc7A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc7A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 75% of requests receives 404 response code for 15 minutes then send email notification to platform_team_ag and create ticket with severity Critical. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 75
    severity         = 1
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("404")
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC8A.1
  #
  # Condition: 
  # If at least 50% of requests receives 502 response code for 5 minutes then send email notification to platform_team_ag and 
  # create ticket with severity Normal
  #
  # Action group: platform_team_ag
  alert_muc8A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc8A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 50% of requests receives 502 response code for 5 minutes then send email notification to platform_team_ag and create ticket with severity Normal. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50
    severity         = 3
    frequency        = "PT5M"
    window_size      = "PT5M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("502")
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC8A.2
  #
  # Condition: 
  # If at least 75% of requests receives 502 response code for 5 minutes then send email notification to platform_team_ag and 
  # create ticket with severity Critical
  #
  # Action group: platform_team_ag
  alert_muc8A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc8A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 75% of requests receives 502 response code for 5 minutes then send email notification to platform_team_ag and create ticket with severity Critical. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 75
    severity         = 1
    frequency        = "PT5M"
    window_size      = "PT5M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("502")
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC9A.1
  #
  # Condition: 
  # If at least 50% of gateway requests receives 401 / 403 response code for 15 minutes then send email notification to platform_team_ag and 
  # create ticket with severity Normal
  #
  # Action group: platform_team_ag
  alert_muc9A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc9A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 50% of gateway requests receives 401 / 403 response code for 15 minutes then send email notification to platform_team_ag and create ticket with severity Normal. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 50
    severity         = 3
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "GatewayResponseCode"
        operator = "Include"
        values   = list("401", "403")
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC9A.2
  #
  # Condition: 
  # If at least 75% of gateway requests receives 401 / 403 response code for 15 minutes then send email notification to platform_team_ag and 
  # create ticket with severity Critical
  #
  # Action group: platform_team_ag
  alert_muc9A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc9A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 75% of gateway requests receives 401 / 403 response code for 15 minutes then send email notification to platform_team_ag and create ticket with severity Critical. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 75
    severity         = 1
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      },
      {
        name     = "GatewayResponseCode"
        operator = "Include"
        values   = list("401", "403")
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC10A.1
  #
  # Condition: 
  # If capacity of APIM instances increase to more than 70% for 30 minutes send notification to platform_team_ag
  #
  # Action group: platform_team_ag
  alert_muc10A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc10A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Capacity"
    description      = format("%s %s", "If capacity of APIM instances increase to more than 70% for 30 minutes send notification to platform_team_ag. More details:", local.more_details)
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
    severity         = 3
    frequency        = "PT30M"
    window_size      = "PT30M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC10A.2
  #
  # Condition: 
  # If capacity of APIM instances falls lower than 50% for 30 minutes send notification to platform_team_ag
  #
  # Action group: platform_team_ag
  alert_muc10A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    alert_name       = "apim-muc10A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Capacity"
    description      = format("%s %s", "If capacity of APIM instances falls lower than 50% for 30 minutes send notification to platform_team_ag. More details:", local.more_details)
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 50
    severity         = 3
    frequency        = "PT30M"
    window_size      = "PT30M"

    dimensions = [
      {
        name     = "Location"
        operator = "Include"
        values   = list(var.location_code)
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }
}
