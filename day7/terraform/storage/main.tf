provider "azurerm" {
  version = "~> 2.6.0"
  features {}
}

resource "azurerm_storage_account" "website" {
  name                     = "${var.prefix}fe${var.env}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "index.html"
  }

  tags = {
    environment = "${var.env}"
  }
}

resource "azurerm_storage_account" "resources" {
  name                     = "${var.prefix}resources${var.env}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "${var.env}"
  }
}


output "staticwebsite_primary_web_endpoint" {
  value       = azurerm_storage_account.website.primary_web_endpoint
  description = "SPA Endpoint"
}

output "resources_primary_connection_string" {
  value       = azurerm_storage_account.resources.primary_connection_string
  description = "SPA Endpoint"
}
