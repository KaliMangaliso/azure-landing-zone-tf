variable "name"                     { type = string }
variable "location"                 { type = string }
variable "resource_group"           { type = string }
variable "sku_name"                 { type = string }
variable "tenant_id"                { type = string }
variable "purge_protection_enabled" { type = bool }
variable "tags"                     { type = map(string) }

resource "azurerm_key_vault" "kv" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group
  tenant_id                     = var.tenant_id
  sku_name                      = var.sku_name
  purge_protection_enabled      = var.purge_protection_enabled
  soft_delete_retention_days    = 7
  public_network_access_enabled = true
  tags                          = var.tags
}

output "id" { value = azurerm_key_vault.kv.id }