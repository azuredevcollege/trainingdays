resource "azurerm_storage_account" "resources" {
  name                     = "${var.prefix}resources${var.env}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true

  tags = {
    environment = var.env
  }
}

resource "azurerm_storage_account" "functions" {
  name                     = "${var.prefix}funcs${var.env}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.env
  }
}

output "resources_primary_connection_string" {
  value       = azurerm_storage_account.resources.primary_connection_string
  description = "Resources Storage Connection"
}

output "funcs_primary_connection_string" {
  value       = azurerm_storage_account.functions.primary_connection_string
  description = "Functions Storage Connection"
}

