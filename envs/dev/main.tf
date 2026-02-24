terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.111.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 1) Resource Group
module "rg" {
  source   = "../../modules/rg"
  name     = "rg-mkt-dev-jhb"
  location = var.location
  tags     = var.tags
}

# 2) Log Analytics
module "loganalytics" {
  source            = "../../modules/loganalytics"
  name              = "law-mkt-dev-jhb"
  location          = var.location
  resource_group    = module.rg.name
  retention_in_days = 30
  tags              = var.tags
}

# 3) Hub & Spoke VNets
module "vnet_hub" {
  source         = "../../modules/vnet"
  name           = "vnet-mkt-hub-jhb"
  location       = var.location
  resource_group = module.rg.name
  address_space  = ["10.10.0.0/16"]
  subnets = {
    "AzureBastionSubnet" = "10.10.0.0/27"
  }
  tags = var.tags
}

module "vnet_spoke_app" {
  source         = "../../modules/vnet"
  name           = "vnet-mkt-app-dev-jhb"
  location       = var.location
  resource_group = module.rg.name
  address_space  = ["10.11.0.0/16"]
  subnets = {
    "app-subnet" = "10.11.1.0/24"
  }
  tags = var.tags
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "hub-to-spoke"
  resource_group_name          = module.rg.name
  virtual_network_name         = module.vnet_hub.vnet_name
  remote_virtual_network_id    = module.vnet_spoke_app.vnet_id
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "spoke-to-hub"
  resource_group_name          = module.rg.name
  virtual_network_name         = module.vnet_spoke_app.vnet_name
  remote_virtual_network_id    = module.vnet_hub.vnet_id
  allow_virtual_network_access = true
}

# 4) Key Vault
module "keyvault" {
  source                   = "../../modules/keyvault"
  name                     = "kv-mkt-dev-jhb"
  location                 = var.location
  resource_group           = module.rg.name
  sku_name                 = "standard"
  purge_protection_enabled = true
  tenant_id                = var.tenant_id
  tags                     = var.tags
}

# 5) Baseline Policies at RG scope
module "policy" {
  source               = "../../modules/policy"
  scope_resource_group = module.rg.id
  allowed_locations    = var.allowed_locations
  required_tags        = ["owner", "costCenter", "env"]
}
