provider "azurerm" {
  version = "~> 2.49.0"
  features {
  }
}

resource "azurerm_resource_group" "common" {
  name     = "${var.prefix}-common-rg"
  location = var.location
  tags = {
    environment = var.env
    source      = "AzureDevCollege"
  }
}

# Base Resource Groups

resource "azurerm_resource_group" "data" {
  name     = "${var.prefix}-data-rg"
  location = var.location
  tags = {
    environment = var.env
    source      = "AzureDevCollege"
  }
}

resource "azurerm_resource_group" "storage" {
  name     = "${var.prefix}-storage-rg"
  location = var.location
  tags = {
    environment = var.env
    source      = "AzureDevCollege"
  }
}

resource "azurerm_resource_group" "messaging" {
  name     = "${var.prefix}-messaging-rg"
  location = var.location
  tags = {
    environment = var.env
    source      = "AzureDevCollege"
  }
}

# Modules

module "common" {
  source              = "./common"
  location            = azurerm_resource_group.common.location
  resource_group_name = azurerm_resource_group.common.name
  env                 = var.env
  prefix              = var.prefix
}

module "data" {
  source              = "./data"
  location            = azurerm_resource_group.data.location
  resource_group_name = azurerm_resource_group.data.name
  env                 = var.env
  prefix              = var.prefix
  cosmosdbname        = var.cosmosdbname
  cosmoscontainername = var.cosmoscontainername
  sqldbusername       = var.sqldbusername
  sqldbpassword       = var.sqldbpassword
}

module "storage" {
  source              = "./storage"
  location            = azurerm_resource_group.storage.location
  resource_group_name = azurerm_resource_group.storage.name
  env                 = var.env
  prefix              = var.prefix
}

module "messaging" {
  source              = "./messaging"
  location            = azurerm_resource_group.messaging.location
  resource_group_name = azurerm_resource_group.messaging.name
  env                 = var.env
  prefix              = var.prefix
}

# Save Secrets

# Common

output "appinsights" {
  value = module.common.ai_instrumentation_key
  sensitive = true
}
output "appinsights_base64" {
  value = base64encode(module.common.ai_instrumentation_key)
  sensitive = true
}

# Data

output "cosmos_endpoint_base64" {
  value = base64encode(module.data.cosmos_endpoint)
  sensitive = true
}

output "cosmos_primary_master_key_base64" {
  value = base64encode(module.data.cosmos_primary_master_key)
  sensitive = true
}

output "sqldb_connectionstring_base64" {
  value = base64encode(module.data.sqldb_connectionstring)
  sensitive = true
}

output "search_primary_key_base64" {
  value = base64encode(module.data.search_primary_key)
  sensitive = true
}

output "search_name_base64" {
  value = base64encode(module.data.search_name)
  sensitive = true
}

output "textanalytics_endpoint_base64" {
  value = base64encode(module.data.textanalytics_endpoint)
  sensitive = true
}

output "textanalytics_key_base64" {
  value = base64encode(module.data.textanalytics_key)
  sensitive = true
}

# Storage

output "resources_primary_connection_string_base64" {
  value = base64encode(module.storage.resources_primary_connection_string)
  sensitive = true
}

output "funcs_primary_connection_string_base64" {
  value = base64encode(module.storage.funcs_primary_connection_string)
  sensitive = true
}

# Messaging

output "thumbnail_listen_connectionstring_base64" {
  value = base64encode(module.messaging.thumbnail_listen_connectionstring)
  sensitive = true
}

output "thumbnail_send_connectionstring_base64" {
  value = base64encode(module.messaging.thumbnail_send_connectionstring)
  sensitive = true
}

output "contacts_listen_connectionstring_base64" {
  value = base64encode(module.messaging.contacts_listen_connectionstring)
  sensitive = true
}

output "contacts_listen_with_entity_connectionstring_base64" {
  value = base64encode(module.messaging.contacts_listen_with_entity_connectionstring)
  sensitive = true
}

output "contacts_send_connectionstring_base64" {
  value = base64encode(module.messaging.contacts_send_connectionstring)
  sensitive = true
}

output "visitreports_listen_connectionstring_base64" {
  value = base64encode(module.messaging.visitreports_listen_connectionstring)
  sensitive = true
}

output "visitreports_send_connectionstring_base64" {
  value = base64encode(module.messaging.visitreports_send_connectionstring)
  sensitive = true
}
