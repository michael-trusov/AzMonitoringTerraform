variable "environment" { default = "personal" }
variable "location" { default = "West Europe" }
variable "location_code" { default = "we" }
variable "project_name" { default = "apim" }
variable "brand" { default = "cust" }

variable "api_management" { default = {} }

variable "app_service_plan_id" { default = {} }

variable "azurerm_log_analytics_workspace_id" {}

variable "activity_log_alerts" {
  description = "The Map with Activity Log Alerts."
  type        = map(any)
  default     = null
}
variable "action_groups" {
  description = "The Map with Action Groups variables."
  type        = map(any)
  default     = null
}

variable "rule_action_groups" {
  description = "The Map with Rule Action Groups variables."
  type        = map(any)
  default     = null
}

variable "query_alerts" {
  description = "The Map with Query Alerts."
  type        = map(any)
  default     = null
}

variable "metric_alerts" {
  description = "Metric Alerts"
  type        = map(any)
}

variable "templates" {
  description = "Templates."
  type        = map(any)
  default     = null
}
