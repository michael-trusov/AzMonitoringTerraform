variable "subscription_id" { default = "e321efb2-bff7-4ec0-a4a7-c5f95abef641" }
variable "tenant_id" { default = "bd6704ff-1437-477c-9ac9-c30d6f5133c5" }
variable "costcenter" { default = "9100032" }
variable "environment" { default = "sandbox" }
variable "location" { default = "Canada Central" }
variable "location_code" { default = "cc" }
variable "project_name" { default = "apidev" }
variable "brand" { default = "ctc" }

variable "monitoring_frontdoor_id" {}

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

variable "frontdoor_metric_alerts" {
  description = "Azure Frontdoor Metric Alerts."
  type        = map(any)
  default     = null
}

variable "templates" {
  description = "Templates."
  type        = map(any)
  default     = null
}
