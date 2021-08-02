/*
  Notes:
   1. 'severity':  (Optional) Severity of the alert. Possible values include: 0, 1, 2, 3, or 4. 
      (from the most critical to the least one)
      0 - Critical
      1 - Error
      2 - Warning
      3 - Informational
      4 - Verbose
   2. 'frequency': (Required) Frequency (in minutes) at which rule condition should be evaluated. Values must be 
      between 5 and 1440 (inclusive).

   3. 'time_window': (Required) Time window for which data needs to be fetched for query (must be greater than or 
      equal to frequency). Values must be between 5 and 2880 (inclusive).
*/

locals {
  /*
    Alert - MUC1A.1
    
    Condition: 
    If at least 50% of requests are processed with duration higher than 500ms and 
    it is observable during 5 mins of time - report incident to Platform team with minimal severity.
  */
  alert_muc1A1_description = format("%s %s", "If at least 50% of requests are processed with duration higher than 500ms and it is observable during 5 mins of time - report incident to Platform team with minimal severity. More details:", local.more_details)
  alert_muc1A1 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc1A1_description
    severity      = 4
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc1A1-test"

    query = <<-QUERY
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

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC1A.2
    
    Condition: 
    If at least 50% of requests are processed with duration higher than 1000ms for 5 mins of time 
    - report incident to Platform team with severity major and send e-mail with template to Platform team.
  */

  alert_muc1A2_description = format("%s %s", "If at least 50% of requests are processed with duration higher than 1000ms for 5 mins of time ( or maybe without waiting) - report incident to Platform team with severity major and send e-mail with template to Platform team. More details:", local.more_details)
  alert_muc1A2 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc1A2_description
    severity      = 2
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc1A2"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithDelay = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m) and BackendTime > 1000
    | count
    | project TempCol = "Temp", NumberOfDelayedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithDelay on TempCol) on TempCol  
    | extend PercentageOfDelayedRequests = (NumberOfDelayedRequests * 100)/NumberOfRequests  
    | project PercentageOfDelayedRequests
    | where PercentageOfDelayedRequests >= 50
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC1A.3
    
    Condition: 
    If 95% or requests is processed with duration higher than 500ms - for 1 mins of time - report incident to Platform team 
    with severity Critical and send e-mail with template to Platform team and send SMS to Platform team.
  */

  alert_muc1A3_description = format("%s %s", "If 95% or requests is processed with duration higher than 500ms - for 1 mins of time - report incident to Platform team with severity Critical and send e-mail with template to Platform team and send SMS to Platform team. More details:", local.more_details)
  alert_muc1A3 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc1A3_description
    severity      = 1
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc1A3"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(1m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithDelay = ApiManagementGatewayLogs
    | where TimeGenerated > ago(1m) and BackendTime > 500
    | count
    | project TempCol = "Temp", NumberOfDelayedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithDelay on TempCol) on TempCol  
    | extend PercentageOfDelayedRequests = (NumberOfDelayedRequests * 100)/NumberOfRequests  
    | project PercentageOfDelayedRequests
    | where PercentageOfDelayedRequests >= 95
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC1A.4
    
    Condition: 
    If 95% or requests is processed with duration higher than 1000ms - for 1 min of time - report incident to 
    Platform team with severity BLOCKER and send e-mail with template to Platform team and send SMS to Platform team 
    and Call Platform team.
  */
  alert_muc1A4_description = format("%s %s", "If 95% or requests is processed with duration higher than 1000ms - for 1 min of time - report incident to Platform team with severity BLOCKER and send e-mail with template to Platform team and send SMS to Platform team and Call Platform team. More details:", local.more_details)
  alert_muc1A4 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc1A4_description
    severity      = 0
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc1A4"

    query = <<-QUERY
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

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_critical_ag.group_name
    action_group_id   = ""
  }

  # Condition
  # If at least 50% of requests are processed with duration higher than 900 ms and it is observable during 5 min 
  # of time and part of APIM is greater than 400 ms - report incident to Platform team with Critical severity.
  #
  # Action group: platform_team_ag
  alert_muc2A1 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc2A1"
    query         = <<-QUERY
    ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | extend ApimTime = TotalTime - BackendTime
    | summarize MedianOfTotalTime=percentile(TotalTime, 50), MedianOfApimTime=percentile(ApimTime, 50) by bin(TimeGenerated, 5m) 
    | project MedianOfTotalTime, MedianOfApimTime, TimeGenerated
    | where MedianOfTotalTime > 900 and MedianOfApimTime > 400
    QUERY

    description       = format("%s %s", "If at least 50% of requests are processed with duration higher than 900 ms and it is observable during 5 min of time and part of APIM is greater than 400 ms - report incident to Platform team with Critical severity. More details:", local.more_details)
    severity          = "3"
    frequency         = "5"
    time_window       = "30"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  # Condition
  # If at least 50% of requests are processed with duration higher than 900ms and it is observable during 5 min of time 
  # and part of APIM is greater than 800 ms - report incident to Platform team with Critical severity.
  #
  # Action Group: platform_team_major_ag
  alert_muc2A2 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc2A2"
    query         = <<-QUERY
    ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | extend ApimTime = TotalTime - BackendTime
    | summarize MedianOfTotalTime=percentile(TotalTime, 50), MedianOfApimTime=percentile(ApimTime, 50) by bin(TimeGenerated, 5m) 
    | project MedianOfTotalTime, MedianOfApimTime, TimeGenerated
    | where MedianOfTotalTime > 900 and MedianOfApimTime > 800
    QUERY

    description       = format("%s %s", "If at least 50% of requests are processed with duration higher than 900ms and it is observable during 5 min of time and part of APIM is greater than 800 ms - report incident to Platform team with Critical severity. More details:", local.more_details)
    severity          = "1"
    frequency         = "5"
    time_window       = "30"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Condition
  # If at least 50% of requests are processed with duration higher than 1800 ms and 
  # it is observable during 5 min of time and part of APIM is greater than 400 ms - report incident to Platform team with Critical severity.
  #
  # Action Group: platform_team_major_ag
  alert_muc2A3 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc2A3"
    query         = <<-QUERY
      ApiManagementGatewayLogs
      | where TimeGenerated > ago(5m)
      | extend ApimTime = TotalTime - BackendTime
      | summarize MedianOfTotalTime=percentile(TotalTime, 50), MedianOfApimTime=percentile(ApimTime, 50) by bin(TimeGenerated, 5m) 
      | project MedianOfTotalTime, MedianOfApimTime, TimeGenerated
      | where MedianOfTotalTime > 1800 and MedianOfApimTime > 400
      QUERY

    description       = format("%s %s", "If at least 50% of requests are processed with duration higher than 1800 ms and it is observable during 5 min of time and part of APIM is greater than 400 ms - report incident to Platform team with Critical severity. More details:", local.more_details)
    severity          = "1"
    frequency         = "5"
    time_window       = "30"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  # Condition
  # If at least 50% of requests are processed with duration higher than 1800 ms and 
  # it is observable during 5 min of time and part of APIM is greater than 800 ms - report incident to Platform team with BLOCKER severity.
  #
  # Action Group: platform_team_critical_ag
  alert_muc2A4 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc2A4"
    query         = <<-QUERY
      ApiManagementGatewayLogs
      | where TimeGenerated > ago(5m)
      | extend ApimTime = TotalTime - BackendTime
      | summarize MedianOfTotalTime=percentile(TotalTime, 50), MedianOfApimTime=percentile(ApimTime, 50) by bin(TimeGenerated, 5m) 
      | project MedianOfTotalTime, MedianOfApimTime, TimeGenerated
      | where MedianOfTotalTime > 1800 and MedianOfApimTime > 800
      QUERY

    description       = format("%s %s", "If at least 50% of requests are processed with duration higher than 1800 ms and it is observable during 5 min of time and part of APIM is greater than 800 ms - report incident to Platform team with BLOCKER severity. More details:", local.more_details)
    severity          = "0"
    frequency         = "5"
    time_window       = "30"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_critical_ag.group_name
    action_group_id   = ""
  }

  # Condition
  # If at least 95% of requests are processed with duration higher than 900 ms and 
  # it is observable during 1 min of time and part of APIM is greater than 400 ms - report incident to Platform team with BLOCKER severity.
  #
  # Note: frequency must be in a range 5 - 1440 (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert)
  #
  # Action Group: platform_team_critical_ag
  alert_muc2A5 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc2A5"
    query         = <<-QUERY
      ApiManagementGatewayLogs
      | where TimeGenerated > ago(1m)
      | extend ApimTime = TotalTime - BackendTime
      | summarize MedianOfTotalTime=percentile(TotalTime, 95), MedianOfApimTime=percentile(ApimTime, 95) by bin(TimeGenerated, 1m) 
      | project MedianOfTotalTime, MedianOfApimTime, TimeGenerated
      | where MedianOfTotalTime > 900 and MedianOfApimTime > 400
      QUERY

    description       = format("%s %s", "If at least 95% of requests are processed with duration higher than 900 ms and it is observable during 1 min of time and part of APIM is greater than 400 ms - report incident to Platform team with BLOCKER severity. More details:", local.more_details)
    severity          = "0"
    frequency         = "5"
    time_window       = "30"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_critical_ag.group_name
    action_group_id   = ""
  }

  # Condition
  # If at least 95% of requests are processed with duration higher than 1800 and 
  # it is observable during 1 min of time and part of APIM is greater than 800 ms - report incident to Platform team with BLOCKER severity.
  #
  # Note: frequency must be in a range 5 - 1440 (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert)
  #
  # Action Group: platform_team_critical_ag
  alert_muc2A6 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    query_name    = "apim-muc2A6"
    query         = <<-QUERY
      ApiManagementGatewayLogs
      | where TimeGenerated > ago(1m)
      | extend ApimTime = TotalTime - BackendTime
      | summarize MedianOfTotalTime=percentile(TotalTime, 95), MedianOfApimTime=percentile(ApimTime, 95) by bin(TimeGenerated, 1m) 
      | project MedianOfTotalTime, MedianOfApimTime, TimeGenerated
      | where MedianOfTotalTime > 1800 and MedianOfApimTime > 800
      QUERY

    description       = format("%s %s", "If at least 95% of requests are processed with duration higher than 1800 and it is observable during 1 min of time and part of APIM is greater than 800 ms - report incident to Platform team with BLOCKER severity. More details:", local.more_details)
    severity          = "0"
    frequency         = "5"
    time_window       = "30"
    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_critical_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC3A.1
    
    Condition: 
    If at least 50% of requests receives response with 502 response code for 5 minutes then send email notification 
    to Platform team & API Developer Team.
  */

  alert_muc3A1_description = format("%s %s", "If at least 50% of requests receives response with 502 response code for 5 minutes then send email notification to Platform team & API Developer Team. More details:", local.more_details)
  alert_muc3A1 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc3A1_description
    severity      = 3
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc3A1"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m) and BackendResponseCode == 502
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 50
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }


  /*
    Alert - MUC3A.2
    
    Condition: 
    If at least 75% of requests receives response with 502 response code for 1 minute then send email notification
    to Platform team and create Incident ticket in Service Now.
  */

  alert_muc3A2_description = format("%s %s", "If at least 75% of requests receives response with 502 response code for 1 minute then send email notification to Platform team and create Incident ticket in Service Now. More details:", local.more_details)
  alert_muc3A2 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc3A2_description
    severity      = 1
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc3A2"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(1m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(1m) and BackendResponseCode == 502
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 75
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC4A.1
    
    Condition: 
    If at least 50% of requests receives response with 500 or 400 response code for 10 minutes 
    then send email notification to API Developer Team.
  */

  alert_muc4A1_description = format("%s %s", "If at least 50% of requests receives response with 500 or 400 response code for 10 minutes then send email notification to API Developer Team. More details:", local.more_details)
  alert_muc4A1 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc4A1_description
    severity      = 3
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc4A1"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(10m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(10m) and (BackendResponseCode == 500 or BackendResponseCode == 400)
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 50
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC4A.2
    
    Condition: 
    If at least 75% of requests receives response with 500 or 400 response code for 5 minutes then 
    send email notification to API Developer Team and create ticket with Severity Critical in Service Now for the API Developer Team.
  */

  alert_muc4A2_description = format("%s %s", "If at least 75% of requests receives response with 500 or 400 response code for 5 minutes then send email notification to API Developer Team and create ticket with Severity Critical in Service Now for the API Developer Team. More details:", local.more_details)
  alert_muc4A2 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc4A2_description
    severity      = 1
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc4A2"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m) and (BackendResponseCode == 500 or BackendResponseCode == 400)
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 75
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC5A.1
    
    Condition: 
    If at least 50% of requests receives 403 response code for 10 minutes then send email notification 
    to API Developer Team and create ticket with severity Normal in Service Now for further investigation.
  */

  alert_muc5A1_description = format("%s %s", "If at least 50% of requests receives 403 response code for 10 minutes then send email notification to API Developer Team and create ticket with severity Normal in Service Now for further investigation. More details:", local.more_details)
  alert_muc5A1 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc5A1_description
    severity      = 2
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc5A1"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(10m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(10m) and BackendResponseCode == 403
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 50
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC5A.2
    
    Condition: 
    If at least 75% of requests receives 403 response code for 5 minutes then send email notification to 
    API Developer Team and create ticket with severity Critical in Service Now for further investigation.
  */

  alert_muc5A2_description = format("%s %s", "If at least 75% of requests receives 403 response code for 5 minutes then send email notification to API Developer Team and create ticket with severity Critical in Service Now for further investigation. More details:", local.more_details)
  alert_muc5A2 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc5A2_description
    severity      = 1
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc5A2"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m) and BackendResponseCode == 403
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 75
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_critical_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC6A.1
    
    Condition: 
    If at least 50% of requests receives 401 response code for 10 minutes then send email notification to
    API Developer Team and create ticket with severity Normal in Service Now for further investigation.
  */

  alert_muc6A1_description = format("%s %s", " More details:", local.more_details)
  alert_muc6A1 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc6A1_description
    severity      = 3
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc6A1"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(10m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(10m) and BackendResponseCode == 401
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 50
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC6A.2
    
    Condition: 
    If at least 75% of requests receives 401 response code for 5 minutes then send email notification 
    to API Developer Team and create ticket with severity Critical in Service Now for further investigation.
  */

  alert_muc6A2_description = format("%s %s", "If at least 75% of requests receives 401 response code for 5 minutes then send email notification to API Developer Team and create ticket with severity Critical in Service Now for further investigation. More details:", local.more_details)
  alert_muc6A2 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc6A2_description
    severity      = 1
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc6A2"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m) and BackendResponseCode == 401
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 75
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_critical_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC7A.1
    
    Condition: 
    If at least 50% of requests receives 404 response code for 10 minutes then send email notification to 
    API Developer Team and create ticket with severity Normal in Service Now for further investigation.
  */

  alert_muc7A1_description = format("%s %s", "If at least 50% of requests receives 404 response code for 10 minutes then send email notification to API Developer Team and create ticket with severity Normal in Service Now for further investigation. More details:", local.more_details)
  alert_muc7A1 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc7A1_description
    severity      = 3
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc7A1"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(10m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(10m) and BackendResponseCode == 404
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 50
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC7A.2
    
    Condition: 
    If at least 75% of requests receives 404 response code for 5 minutes then send email notification to 
    API Developer Team and create ticket with severity Critical in Service Now for further investigation.
  */

  alert_muc7A2_description = format("%s %s", "If at least 75% of requests receives 404 response code for 5 minutes then send email notification to API Developer Team and create ticket with severity Critical in Service Now for further investigation. More details:", local.more_details)
  alert_muc7A2 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc7A2_description
    severity      = 1
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc7A2"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(5m) and BackendResponseCode == 404
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 75
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_critical_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC8A.1
    
    Condition: 
    If at least 50% of requests (use Gateway Response Code) receives 502 response code for 10 minutes then send 
    email notification to Platform Team and create ticket with severity Major in Service Now for further investigation.
  */

  alert_muc8A1_description = format("%s %s", "If at least 50% of requests (GatewayResponseCode) receives 502 response code for 10 minutes then send email notification to Platform Team and create ticket with severity Major in Service Now for further investigation. More details:", local.more_details)
  alert_muc8A1 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc8A1_description
    severity      = 2
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc8A1"

    query = <<-QUERY
    let AllRequests = ApiManagementGatewayLogs
    | where TimeGenerated > ago(10m)
    | count
    | project TempCol = "Temp", NumberOfRequests = Count;
    let RequestsWithError = ApiManagementGatewayLogs
    | where TimeGenerated > ago(10m) and ResponseCode == 502
    | count
    | project TempCol = "Temp", NumberOfFailedRequests = Count;
    AllRequests  
    | join (AllRequests | join RequestsWithError on TempCol) on TempCol  
    | extend PercentageOfFailedRequests = (NumberOfFailedRequests * 100)/NumberOfRequests  
    | project PercentageOfFailedRequests
    | where PercentageOfFailedRequests >= 50
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_major_ag.group_name
    action_group_id   = ""
  }

  /*
    Alert - MUC8A.2
    
    Condition: 
    If at least 75% of requests receives 502 response code for 5 minutes then send email notification to Platform Team 
    and create ticket with severity Critical in Service Now for further investigation.
  */

  alert_muc8A2_description = format("%s %s", "If at least 75% of requests receives 502 response code for 5 minutes then send email notification to Platform Team and create ticket with severity Critical in Service Now for further investigation. More details:", local.more_details)
  alert_muc8A2 = {
    environment   = var.environment
    location_code = var.location_code
    location      = var.location
    project_name  = var.project_name
    description   = local.alert_muc8A2_description
    severity      = 1
    frequency     = 5
    time_window   = 30

    query_name = "apim-muc8A2"

    query = <<-QUERY
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
    | where PercentageOfFailedRequests >= 75
    QUERY

    trigger_operator  = "GreaterThan"
    trigger_threshold = "0"

    action_group_name = local.platform_team_critical_ag.group_name
    action_group_id   = ""
  }
}
