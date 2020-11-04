provider "azurerm" {
  version = "~> 2.34.0"
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "adc-tfstate-rg"
    storage_account_name = "tfstateadadc"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_resource_group" "common" {
  name     = "${var.prefix}-common-rg"
  location = var.location
  tags = {
    environment = var.env
  }
}

# Base Resource Groups

resource "azurerm_resource_group" "data" {
  name     = "${var.prefix}-data-rg"
  location = var.location
  tags = {
    environment = var.env
  }
}

resource "azurerm_resource_group" "storage" {
  name     = "${var.prefix}-storage-rg"
  location = var.location
  tags = {
    environment = var.env
  }
}

resource "azurerm_resource_group" "messaging" {
  name     = "${var.prefix}-messaging-rg"
  location = var.location
  tags = {
    environment = var.env
  }
}

resource "azurerm_resource_group" "k8s" {
  name     = "${var.prefix}-k8s-rg"
  location = var.location
  tags = {
    environment = var.env
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

module "kubernetes" {
  source              = "./kubernetes"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  env                 = var.env
  prefix              = var.prefix
}

# Save Secrets

# Common

resource "azurerm_key_vault_secret" "appinsights" {
  name         = "${var.prefix}APPINSIGHTSKEY"
  value        = base64encode(module.common.ai_instrumentation_key)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "appinsights_decoded" {
  name         = "${var.prefix}APPINSIGHTSKEYDEC"
  value        = module.common.ai_instrumentation_key
  key_vault_id = module.common.keyvaultid
}

# Data

resource "azurerm_key_vault_secret" "cosmos_endpoint" {
  name         = "${var.prefix}COSMOSENDPOINT"
  value        = base64encode(module.data.cosmos_endpoint)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "cosmos_primary_master_key" {
  name         = "${var.prefix}COSMOSPRIMARYKEY"
  value        = base64encode(module.data.cosmos_primary_master_key)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "cosmos_secondary_master_key" {
  name         = "${var.prefix}COSMOSSECONDARYKEY"
  value        = base64encode(module.data.cosmos_secondary_master_key)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "sqldb_connectionstring" {
  name         = "${var.prefix}SQLDBCONNECTIONSTRING"
  value        = base64encode(module.data.sqldb_connectionstring)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "search_primary_key" {
  name         = "${var.prefix}SEARCHPRIMARYKEY"
  value        = base64encode(module.data.search_primary_key)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "search_name" {
  name         = "${var.prefix}SEARCHNAME"
  value        = base64encode(module.data.search_name)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "textanalytics_endpoint" {
  name         = "${var.prefix}TAENDPOINT"
  value        = base64encode(module.data.textanalytics_endpoint)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "textanalytics_key" {
  name         = "${var.prefix}TAKEY"
  value        = base64encode(module.data.textanalytics_key)
  key_vault_id = module.common.keyvaultid
}

# Storage

resource "azurerm_key_vault_secret" "resources_primary_connection_string" {
  name         = "${var.prefix}RESOURCESCONNECTIONSTRING"
  value        = base64encode(module.storage.resources_primary_connection_string)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "funcs_primary_connection_string" {
  name         = "${var.prefix}FUNCTIONSCONNECTIONSTRING"
  value        = base64encode(module.storage.funcs_primary_connection_string)
  key_vault_id = module.common.keyvaultid
}

# Messaging

resource "azurerm_key_vault_secret" "thumbnail_listen_connectionstring" {
  name         = "${var.prefix}THUMBNAILLISTENCONNSTR"
  value        = base64encode(module.messaging.thumbnail_listen_connectionstring)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "thumbnail_send_connectionstring" {
  name         = "${var.prefix}THUMBNAILSENDCONNSTR"
  value        = base64encode(module.messaging.thumbnail_send_connectionstring)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "contacts_listen_connectionstring" {
  name         = "${var.prefix}CONTACTSLISTENCONNSTR"
  value        = base64encode(module.messaging.contacts_listen_connectionstring)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "contacts_listen_with_entity_connectionstring" {
  name = "${var.prefix}CONTACTSLISTENENTITYCONNSTR"
  value = base64encode(
    module.messaging.contacts_listen_with_entity_connectionstring,
  )
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "contacts_send_connectionstring" {
  name         = "${var.prefix}CONTACTSSENDCONNSTR"
  value        = base64encode(module.messaging.contacts_send_connectionstring)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "visitreports_listen_connectionstring" {
  name         = "${var.prefix}VRLISTENCONNSTR"
  value        = base64encode(module.messaging.visitreports_listen_connectionstring)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "visitreports_send_connectionstring" {
  name         = "${var.prefix}VRSENDCONNSTR"
  value        = base64encode(module.messaging.visitreports_send_connectionstring)
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "hostname" {
  name         = "${var.prefix}HOSTNAME"
  value        = module.kubernetes.nip_hostname
  key_vault_id = module.common.keyvaultid
}

