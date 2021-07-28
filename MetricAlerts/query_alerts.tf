locals {
  # Alert - MUC1A.1
  #
  # Condition: 
  # If at least 50% of requests are processed with duration higher than 500 ms and it is observable during 5 min of time - report incident to 
  # Platform team with minimal severity.
  #
  # Action group: platform_team_ag
  alert_muc1A1 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc1A1"
    query         = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithDelay = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m) and BackendTime > 500
    | count
    | project TempCol = "Temp", NumberOfDelayedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithDelay on TempCol) on TempCol  
    | extend PercentageOfDelayedRequests = (NumberOfDelayedRequests * 100)/NumberOfRequests  
    | project PercentageOfDelayedRequests
    | where PercentageOfDelayedRequests >= 50
    QUERY

    description       = format("%s %s", "If at least 50% of requests are processed with duration higher than 500ms and it is observable during 5 mins of time - report incident to Platform team with minimal severity. More details:", local.more_details)
    severity          = "4"
    frequency         = "5"
    time_window       = "5"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC1A.2
  #
  # Condition: 
  # If at least 50% of requests are processed with duration higher than 2000 ms in 5 min of time - report 
  # incident to Platform team with severity major 
  #
  # Action group: platform_team_ag
  alert_muc1A2 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc1A2"
    query         = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithDelay = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m) and BackendTime > 2000
    | count
    | project TempCol = "Temp", NumberOfDelayedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithDelay on TempCol) on TempCol  
    | extend PercentageOfDelayedRequests = (NumberOfDelayedRequests * 100)/NumberOfRequests  
    | project PercentageOfDelayedRequests
    | where PercentageOfDelayedRequests >= 50
    QUERY

    description       = format("%s %s", "If at least 50% of requests are processed with duration higher than 2000 ms in 5 min of time - report incident to Platform team with severity major. More details:", local.more_details)
    severity          = "2"
    frequency         = "5"
    time_window       = "5"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC1A.3
  #
  # Condition: 
  # If 95% of requests are processed with duration higher than 400 ms in 5 min of time
  # report incident to Platform team with severity Critical
  #
  # Action Group: platform_team_major_ag
  alert_muc1A3 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc1A3"
    query         = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(1m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithDelay = ApiManagementGatewayLogs
    | where TimeGenerated > ago(1m) and BackendTime > 400
    | count
    | project TempCol = "Temp", NumberOfDelayedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithDelay on TempCol) on TempCol  
    | extend PercentageOfDelayedRequests = (NumberOfDelayedRequests * 100)/NumberOfRequests  
    | project PercentageOfDelayedRequests
    | where PercentageOfDelayedRequests >= 95
    QUERY

    description       = format("%s %s", "If 95% of requests are processed with duration higher than 400 ms in 5 min of time report incident to Platform team with severity Critical. More details:", local.more_details)
    severity          = "1"
    frequency         = "5"
    time_window       = "5"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC1A.4
  #
  # Condition: 
  # If 95% or requests is processed with duration higher than 1000ms - for 5 min of time - report 
  # incident to Platform team with severity BLOCKER and send e-mail with template to Platform team and send SMS to Platform team and Call Platform team
  #
  # Action Group: platform_team_critical_ag
  alert_muc1A4 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc1A4"
    query         = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(1m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithDelay = ApiManagementGatewayLogs
    | where TimeGenerated > ago(1m) and BackendTime > 1000
    | count
    | project TempCol = "Temp", NumberOfDelayedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithDelay on TempCol) on TempCol  
    | extend PercentageOfDelayedRequests = (NumberOfDelayedRequests * 100)/NumberOfRequests  
    | project PercentageOfDelayedRequests
    | where PercentageOfDelayedRequests >= 95
    QUERY

    description       = format("%s %s", "If 95% or requests is processed with duration higher than 1000ms - for 5 minute of time - report incident to Platform team with severity BLOCKER and send e-mail with template to Platform team and send SMS to Platform team and Call Platform team. More details:", local.more_details)
    severity          = "1"
    frequency         = "5"
    time_window       = "5"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Alert - MUC3A.1
  #
  # Condition: 
  # If at least 50% of requests receives response with 502 response code for 5 minutes then 
  # send email notification to Platform team & API Developer Team.
  #
  # Action group: platform_team_ag
  alert_muc3A1 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc3A1"
    query         = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m) and ResponseCode == 502
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 50
    QUERY

    description       = format("%s %s", "If at least 50% of requests receives response with 502 response code for 1 minutes then send email notification to Platform team & API Developer Team. More details:", local.more_details)
    severity          = "1"
    frequency         = "5"
    time_window       = "5"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }  

  # Alert - MUC3A.2
  #
  # Condition: 
  # If at least 75% of requests receives response with 502 response code for 1 minute then 
  # send email notification to Platform team and create Incident ticket in Service Now.
  #
  # Action group: platform_team_ag
  alert_muc3A2 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc3A2"
    query         = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(1m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(1m) and ResponseCode == 502
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 75
    QUERY

    description       = format("%s %s", "If at least 75% of requests receives response with 502 response code for 1 minute then send email notification to Platform team and create Incident ticket in Service Now. More details:", local.more_details)
    severity          = "1"
    frequency         = "5"
    time_window       = "5"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }  
}