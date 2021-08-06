locals {
  # Note: calculation of alerts' threshhold value from the percentage specified in conditions based on number of requests 
  # per second, for now this value is 1 request per second. It can be easily changed in future during of optimization of
  # alerts' conditions
  RequestsPerSecond              = 1
  RequestsPerMinute              = local.RequestsPerSecond * 60
  Get50PercentsRequestsPerMinute = local.RequestsPerMinute * 0.5
  Get75PercentsRequestsPerMinute = local.RequestsPerMinute * 0.75

  # Alert - MUC1A.1
  #
  # Condition: 
  # If at least 50% of requests are processed with duration higher than 500 ms and it is observable during 5 min of time - report incident to 
  # Platform team with minimal severity.
  alert_muc1A1_description = format("%s %s", "If at least 50% of requests are processed with duration higher than 500ms and it is observable during 5 mins of time - report incident to Platform team with minimal severity. More details:", local.more_details)

  apim_alert_muc1A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc1A1_description
    alert_name       = "apim-muc1A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "BackendDuration"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 500
    severity         = 4
    frequency        = "PT1M"
    window_size      = "PT5M"

    dimensions = [
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC1A.2
  #
  # Condition: 
  # If at least 50% of requests are processed with duration higher than 1000ms for 5 mins of time 
  # - report incident to Platform team with severity major and send e-mail with template to Platform team.  
  alert_muc1A2_description = format("%s %s", "If at least 50% of requests are processed with duration higher than 1000ms for 5 mins of time ( or maybe without waiting) - report incident to Platform team with severity major and send e-mail with template to Platform team. More details:", local.more_details)

  apim_alert_muc1A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc1A2_description
    alert_name       = "apim-muc1A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "BackendDuration"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 1000
    severity         = 2
    frequency        = "PT1M"
    window_size      = "PT5M"

    dimensions = [
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC1A.3
  #
  # Condition: 
  # If 95% or requests is processed with duration higher than 500ms - for 1 mins of time - report incident to Platform team 
  # with severity Critical and send e-mail with template to Platform team and send SMS to Platform team. 
  alert_muc1A3_description = format("%s %s", "If 95% or requests is processed with duration higher than 500ms - for 1 mins of time - report incident to Platform team with severity Critical and send e-mail with template to Platform team and send SMS to Platform team. More details:", local.more_details)

  apim_alert_muc1A3 = {
    environment      = var.environment
    project_name     = var.project_name
    location_code    = var.location_code
    description      = local.alert_muc1A3_description
    alert_name       = "apim-muc1A3"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "BackendDuration"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 500
    severity         = 1
    frequency        = "PT1M"
    window_size      = "PT1M"

    dimensions = [
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC1A.4
  #
  # Condition: 
  # If 95% or requests is processed with duration higher than 1000ms - for 1 min of time - report incident to 
  # Platform team with severity BLOCKER and send e-mail with template to Platform team and send SMS to Platform team 
  # and Call Platform team. 
  alert_muc1A4_description = format("%s %s", "If 95% or requests is processed with duration higher than 1000ms - for 1 min of time - report incident to Platform team with severity BLOCKER and send e-mail with template to Platform team and send SMS to Platform team and Call Platform team. More details:", local.more_details)

  apim_alert_muc1A4 = {
    environment      = var.environment
    project_name     = var.project_name
    location_code    = var.location_code
    description      = local.alert_muc1A4_description
    alert_name       = "apim-muc1A4"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "BackendDuration"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 1000
    severity         = 1
    frequency        = "PT1M"
    window_size      = "PT1M"

    dimensions = [
    ]

    action_group_name = local.platform_team_critical_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC3A.1
  #
  # Condition: 
  # If at least 50% of requests receives response with 502 response code for 5 minutes then send email notification 
  # to Platform team & API Developer Team. 
  alert_muc3A1_description = format("%s %s", "If at least 50% of requests receives response with 502 response code for 5 minutes then send email notification to Platform team & API Developer Team. More details:", local.more_details)

  apim_alert_muc3A1 = {
    environment   = var.environment
    location_code = var.location_code
    project_name  = var.project_name
    description   = local.alert_muc3A1_description

    alert_name       = "apim-muc3A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get50PercentsRequestsPerMinute * 5
    severity         = 1
    frequency        = "PT1M"
    window_size      = "PT5M"

    dimensions = [
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("502")
      }
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC3A.1
  #
  # Condition: 
  # If at least 75% of requests receives response with 502 response code for 1 minute then send email notification
  # to Platform team and create Incident ticket in Service Now.
  alert_muc3A2_description = format("%s %s", "If at least 75% of requests receives response with 502 response code for 1 minute then send email notification to Platform team and create Incident ticket in Service Now. More details:", local.more_details)

  apim_alert_muc3A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc3A2_description
    alert_name       = "apim-muc3A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get75PercentsRequestsPerMinute
    severity         = 0
    frequency        = "PT1M"
    window_size      = "PT1M"

    dimensions = [
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("502")
      }
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC4A.1
  #
  # Condition: 
  # If at least 50% of requests receives response with 500 or 400 response code for 15 minutes 
  # then send email notification to API Developer Team.  
  alert_muc4A1_description = format("%s %s", "If at least 50% of requests receives response with 500 or 400 response code for 10 minutes then send email notification to API Developer Team. More details:", local.more_details)

  apim_alert_muc4A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc4A1_description
    alert_name       = "apim-muc4A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get50PercentsRequestsPerMinute * 15
    severity         = 3
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
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
  # If at least 75% of requests receives response with 500 or 400 response code for 5 minutes then 
  # send email notification to API Developer Team and create ticket with Severity Critical in Service Now.
  alert_muc4A2_description = format("%s %s", "If at least 75% of requests receives response with 500 or 400 response code for 5 minutes then send email notification to API Developer Team and create ticket with Severity Critical in Service Now for the API Developer Team. More details:", local.more_details)

  apim_alert_muc4A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc4A2_description
    alert_name       = "apim-muc4A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get75PercentsRequestsPerMinute * 5
    severity         = 1
    frequency        = "PT5M"
    window_size      = "PT5M"

    dimensions = [
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
  # If at least 50% of requests receives 403 response code for 15 minutes then send email notification 
  # to API Developer Team and create ticket with severity Normal in Service Now for further investigation.
  alert_muc5A1_description = format("%s %s", "If at least 50% of requests receives 403 response code for 10 minutes then send email notification to API Developer Team and create ticket with severity Normal in Service Now for further investigation. More details:", local.more_details)

  apim_alert_muc5A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc5A1_description
    alert_name       = "apim-muc5A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get50PercentsRequestsPerMinute * 15
    severity         = 3
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
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
  # If at least 75% of requests receives 403 response code for 5 minutes then send email notification to 
  # API Developer Team and create ticket with severity Critical in Service Now for further investigation.  
  alert_muc5A2_description = format("%s %s", "If at least 75% of requests receives 403 response code for 5 minutes then send email notification to API Developer Team and create ticket with severity Critical in Service Now for further investigation. More details:", local.more_details)

  apim_alert_muc5A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc5A2_description
    alert_name       = "apim-muc5A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get75PercentsRequestsPerMinute * 5
    severity         = 1
    frequency        = "PT5M"
    window_size      = "PT5M"

    dimensions = [
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
  # If at least 50% of requests receives 401 response code for 15 minutes then send email notification to
  # API Developer Team and create ticket with severity Normal in Service Now for further investigation.
  alert_muc6A1_description = format("%s %s", " More details:", local.more_details)

  apim_alert_muc6A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc6A1_description
    alert_name       = "apim-muc6A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get50PercentsRequestsPerMinute * 15
    severity         = 3
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
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
  # If at least 75% of requests receives 401 response code for 5 minutes then send email notification 
  # to API Developer Team and create ticket with severity Critical in Service Now for further investigation.
  alert_muc6A2_description = format("%s %s", "If at least 75% of requests receives 401 response code for 5 minutes then send email notification to API Developer Team and create ticket with severity Critical in Service Now for further investigation. More details:", local.more_details)

  apim_alert_muc6A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc6A2_description
    alert_name       = "apim-muc6A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get75PercentsRequestsPerMinute * 5
    severity         = 1
    frequency        = "PT5M"
    window_size      = "PT5M"

    dimensions = [
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("401")
      }
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC7A.1
  #
  # Condition: 
  # If at least 50% of requests receives 404 response code for 15 minutes then send email notification to 
  # API Developer Team and create ticket with severity Normal in Service Now for further investigation.
  alert_muc7A1_description = format("%s %s", "If at least 50% of requests receives 404 response code for 10 minutes then send email notification to API Developer Team and create ticket with severity Normal in Service Now for further investigation. More details:", local.more_details)

  apim_alert_muc7A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc7A1_description
    alert_name       = "apim-muc7A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get50PercentsRequestsPerMinute * 15
    severity         = 3
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("404")
      }
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC7A.2
  #
  # Condition: 
  # If at least 75% of requests receives 404 response code for 5 minutes then send email notification to 
  # API Developer Team and create ticket with severity Critical in Service Now for further investigation.  
  alert_muc7A2_description = format("%s %s", "If at least 75% of requests receives 404 response code for 5 minutes then send email notification to API Developer Team and create ticket with severity Critical in Service Now for further investigation. More details:", local.more_details)

  apim_alert_muc7A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc7A2_description
    alert_name       = "apim-muc7A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get75PercentsRequestsPerMinute * 5
    severity         = 1
    frequency        = "PT5M"
    window_size      = "PT5M"

    dimensions = [
      {
        name     = "BackendResponseCode"
        operator = "Include"
        values   = list("404")
      }
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC8A.1
  #
  # Condition: 
  # If at least 50% of requests receives 502 response code (GatewayResponseCode) for 15 minutes then send email notification 
  # to Platform Team and create ticket with severity Major in Service Now  
  alert_muc8A1_description = format("%s %s", "If at least 50% of requests (GatewayResponseCode) receives 502 response code for 10 minutes then send email notification to Platform Team and create ticket with severity Major in Service Now for further investigation. More details:", local.more_details)

  apim_alert_muc8A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc8A1_description
    alert_name       = "apim-muc8A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get50PercentsRequestsPerMinute * 15
    severity         = 2
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
      {
        name     = "GatewayResponseCode"
        operator = "Include"
        values   = list("502")
      }
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC8A.2
  #
  # Condition: 
  # If at least 75% of requests receives 502 response code for 5 minutes then send email notification to Platform Team and 
  # create ticket with severity Critical in Service Now
  alert_muc8A2_description = format("%s %s", "If at least 75% of requests receives 502 response code for 5 minutes then send email notification to Platform Team and create ticket with severity Critical in Service Now for further investigation. More details:", local.more_details)

  apim_alert_muc8A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc8A2_description
    alert_name       = "apim-muc8A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get75PercentsRequestsPerMinute * 5
    severity         = 1
    frequency        = "PT5M"
    window_size      = "PT5M"

    dimensions = [
      {
        name     = "GatewayResponseCode"
        operator = "Include"
        values   = list("502")
      }
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC9A.1
  #
  # Condition: 
  # If at least 50% of gateway requests (GatewayResponseCode) receives 401 / 403 response code for 15 minutes then send email notification to platform_team_ag and 
  # create ticket with severity Normal
  alert_muc9A1_description = format("%s %s", "If at least 50% of gateway requests (GatewayResponseCode) receives 401 / 403 response code for 15 minutes then send email notification to platform_team_ag and create ticket with severity Normal. More details:", local.more_details)

  apim_alert_muc9A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc9A1_description
    alert_name       = "apim-muc9A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    description      = format("%s %s", "If at least 50% of gateway requests receives 401 / 403 response code for 15 minutes then send email notification to platform_team_ag and create ticket with severity Normal. More details:", local.more_details)
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get50PercentsRequestsPerMinute * 15
    severity         = 3
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
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
  # If at least 75% of gateway requests receives 401 / 403 response code for 5 minutes then send email notification to platform_team_ag and 
  # create ticket with severity Critical
  alert_muc9A2_description = format("%s %s", "If at least 75% of gateway requests receives 401 / 403 response code for 5 minutes then send email notification to platform_team_ag and create ticket with severity Critical. More details:", local.more_details)

  apim_alert_muc9A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc9A2_description
    alert_name       = "apim-muc9A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = local.Get75PercentsRequestsPerMinute * 5
    severity         = 1
    frequency        = "PT15M"
    window_size      = "PT15M"

    dimensions = [
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
  alert_muc10A1_description = format("%s %s", "If capacity of APIM instances increase to more than 70% for 30 minutes send notification to platform_team_ag. More details:", local.more_details)

  apim_alert_muc10A1 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc10A1_description
    alert_name       = "apim-muc10A1"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Capacity"
    description      = format("%s %s", "If capacity of APIM instances increase to more than 70% for 30 minutes send notification to platform_team_ag. More details:", local.more_details)
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
    severity         = 3
    frequency        = "PT5M"
    window_size      = "PT30M"

    dimensions = [
    ]

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC10A.2
  #
  # Condition: 
  # If capacity of APIM instances falls lower than 50% for 30 minutes send notification to platform_team_ag
  alert_muc10A2_description = format("%s %s", "If capacity of APIM instances falls lower than 50% for 30 minutes send notification to platform_team_ag. More details:", local.more_details)

  apim_alert_muc10A2 = {
    environment      = var.environment
    location_code    = var.location_code
    project_name     = var.project_name
    description      = local.alert_muc10A2_description
    alert_name       = "apim-muc10A2"
    metric_namespace = "Microsoft.ApiManagement/service"
    metric_name      = "Capacity"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 50
    severity         = 3
    frequency        = "PT5M"
    window_size      = "PT30M"

    dimensions = [
    ]

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }
}
