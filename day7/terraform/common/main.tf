
data "azurerm_client_config" "current" {
}

resource "azurerm_application_insights" "appinsights" {
  name                = "${var.prefix}ai${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  retention_in_days   = 90
  tags = {
    environment = var.env
  }
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "${var.prefix}kv${var.env}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = false
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
    object_id = "30674010-37e8-4dbe-b01a-c39beefb3a95"

    secret_permissions = [
      "get",
      "list",
    ]
    certificate_permissions = [
    ]
    key_permissions = [
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

