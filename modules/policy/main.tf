variable "scope_resource_group" { type = string }
variable "allowed_locations"    { type = list(string) }
variable "required_tags"        { type = list(string) }

# ---------------------------
# Policy Definitions (Custom)
# ---------------------------
resource "azurerm_policy_definition" "allowed_locations" {
  name         = "pd-allowed-locations"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Locations (RG scope)"
  policy_rule  = file("${path.module}/allowed_locations.json")

  parameters = jsonencode({
    listOfAllowedLocations = {
      type = "Array"
      metadata = {
        description = "Allowed locations"
        displayName = "Allowed locations"
      }
    }
  })
}

resource "azurerm_policy_definition" "required_tags" {
  name         = "pd-required-tags"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Required Tags"
  policy_rule  = file("${path.module}/required_tags.json")
}

# ---------------------------------
# Policy Assignments (RG-level)
# ---------------------------------

# Allowed Locations assignment at RG scope
resource "azurerm_resource_group_policy_assignment" "allowed_locations" {
  name                 = "pa-allowed-locations"
  resource_group_id    = var.scope_resource_group
  policy_definition_id = azurerm_policy_definition.allowed_locations.id

  parameters = jsonencode({
    listOfAllowedLocations = { value = var.allowed_locations }
  })
}

# Required Tags assignment at RG scope
resource "azurerm_resource_group_policy_assignment" "required_tags" {
  name                 = "pa-required-tags"
  resource_group_id    = var.scope_resource_group
  policy_definition_id = azurerm_policy_definition.required_tags.id
}
