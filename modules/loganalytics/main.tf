variable "name"              { type = string }
variable "location"          { type = string }
variable "resource_group"    { type = string }
variable "retention_in_days" { type = number }
variable "tags"              { type = map(string) }

resource "azurerm_log_analytics_workspace" "law" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = "PerGB2018"
  retention_in_days   = var.retention_in_days
  tags                = var.tags
}

output "id" { value = azurerm_log_analytics_workspace.law.id }
