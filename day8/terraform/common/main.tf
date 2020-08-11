provider "azurerm" {
  version = "~> 2.6.0"
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {
}

# ApplicationInsights
resource "azurerm_application_insights" "appinsights" {
  name                = var.app_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  retention_in_days   = 90
  tags = {
    environment = var.env
  }
}

# User assigned Identity for KeyVault access
resource "azurerm_user_assigned_identity" "kvidentity" {
    name = var.keyvault_identity_name
    resource_group_name = var.resource_group_name
    location = var.location
}

# KeyVault
resource "azurerm_key_vault" "keyvault" {
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "backup",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set",
      "delete",
    ]
    certificate_permissions = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "setissuers",
      "update",
    ]
    key_permissions = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.kvidentity.principal_id

    secret_permissions = [
      "get",
      "list",
    ]
    certificate_permissions = [
        "get",
        "list"
    ]
    key_permissions = [
        "get",
        "list"
    ]
  }

  tags = {
    environment = var.env
  }
}

output "ai_instrumentation_key" {
  value       = azurerm_application_insights.appinsights.instrumentation_key
  description = "Application Insights Instrumentation Key"
}

output "keyvaultid" {
  value       = azurerm_key_vault.keyvault.id
  description = "KeyVault ID"
}

output "kvidentity_id" {
    value       = azurerm_user_assigned_identity.kvidentity.id
    description = "Id User assigned Identity to access KeyVault"
}

output "kvidentity_principal_id" {
    value       = azurerm_user_assigned_identity.kvidentity.principal_id
    description = "Principal Id User assigned Identity to access KeyVault"
}

output "kvidentity_client_id" {
    value       = azurerm_user_assigned_identity.kvidentity.client_id
    description = "Client Id of User assigned Identity to access KeyVault"
}