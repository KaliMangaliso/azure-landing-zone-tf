variable "name"           { type = string }
variable "location"       { type = string }
variable "resource_group" { type = string }
variable "address_space"  { type = list(string) }
variable "subnets" {
  type = map(string) # subnet_name -> cidr
}
variable "tags" { type = map(string) }

resource "azurerm_virtual_network" "vnet" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}

output "vnet_name" { value = azurerm_virtual_network.vnet.name }
output "vnet_id"   { value = azurerm_virtual_network.vnet.id }
