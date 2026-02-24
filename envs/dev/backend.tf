terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstate27175"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"

    # ✅ OIDC + Azure AD auth for the backend (no storage keys)
    use_oidc         = true
    use_azuread_auth = true

    # IDs are not secrets; keep them for clarity and to avoid env drift
    client_id       = "61baab45-4089-4552-aaae-6690d326c5fd"
    tenant_id       = "c64cd139-e40e-4967-bc0b-1a72021890af"
    subscription_id = "80a31f80-0116-4fe0-acf5-ccaae10138a8"
  }
}
