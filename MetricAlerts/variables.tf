variable "subscription_id" { default = "e321efb2-bff7-4ec0-a4a7-c5f95abef641" }
variable "tenant_id" { default = "bd6704ff-1437-477c-9ac9-c30d6f5133c5" }
variable "costcenter" { default = "9100032" }
variable "environment" { default = "sandbox"}
variable "location" { default = "Canada Central" }
variable "location_code" { default = "cc" }
variable "project_name" { default = "apidev" }
variable "brand" { default = "ctc" }

variable "api_management" { default = {} }

variable "log_analytical_id" {
  description = "Requrired for unit testing of terraform module"
  default     = null
}

variable "api_metric_alerts" {
  type = map(object({
    project_name      = string
    alert_name        = string
    metric_name       = string
    aggregation       = string
    operator          = string
    threshold         = number
    severity          = number
    frequency         = string
    window_size       = string
    action_group_name = string

    dimensions = list(object({
      name     = string
      operator = string
      values   = list(string)
    }))
  }))

  validation {
    condition = alltrue([
      for o in var.api_metric_alerts :
      o.project_name != null &&
      o.alert_name != null &&
      o.metric_name != null &&
      contains(["Average", "Count", "Minimum", "Maximum", "Total"], o.aggregation) &&
      contains(["Equals", "NotEquals", "GreaterThan", "GreaterThanOrEqual", "LessThan", "LessThanOrEqual"], o.operator) &&
      o.threshold != 0 &&
      o.severity >= 0 && o.severity < 5 &&
      contains(["PT1M", "PT5M", "PT15M", "PT30M", "PT1H"], o.frequency) &&
      contains(["PT1M", "PT5M", "PT15M", "PT30M", "PT1H", "PT6H", "PT12H", "PT1D"], o.window_size) &&
      o.action_group_name != null
    ])

    error_message = "Values for 'api_metric_alerts' were specified incorrectly."
  }

  default = {
    def = {
      project_name      = ""
      alert_name        = ""
      metric_name       = ""
      aggregation       = "Average"
      operator          = "Equals"
      threshold         = 50
      severity          = 3
      frequency         = "PT1M"
      window_size       = "PT1M"
      action_group_name = ""

      dimensions = [
        {
          name     = "",
          operator = "",
          values   = []
        }
      ]
    }
  }
}


