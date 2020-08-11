provider "azurerm" {
  version = "~> 2.6.0"
  features {
  }
}

terraform {
  backend "azurerm" {
    resource_group_name  = "adc-tf-state"
    storage_account_name = "anmocktfstate"
    container_name       = "tstate"
    key                  = "org.terraform.tfstate"
  }
}

# Resource Groups
resource "azurerm_resource_group" "common" {
  name     = "${var.prefix}-common-${var.env}-rg"
  location = var.location
  tags = {
    environment = var.env
  }
}

resource "azurerm_resource_group" "k8s" {
  name     = "${var.prefix}-k8s-${var.env}-rg"
  location = var.location
  tags = {
    environment = var.env
  }
}

resource "azurerm_resource_group" "data" {
  name     = "${var.prefix}-data-${var.env}-rg"
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

# Modules

module "common" {
  source                 = "./common"
  location               = azurerm_resource_group.common.location
  resource_group_name    = azurerm_resource_group.common.name
  env                    = var.env
  app_insights_name      = var.app_insights_name
  keyvault_name          = var.keyvault_name
  keyvault_identity_name = var.keyvault_identity_name
}

module "kubernetes" {
  source               = "./kubernetes"
  location             = azurerm_resource_group.k8s.location
  resource_group_name  = azurerm_resource_group.k8s.name
  aks_cluster_name     = var.aks_cluster_name
  env                  = var.env
  kvidentity_id        = module.common.kvidentity_id
  kvidentity_client_id = module.common.kvidentity_client_id
}

module "data" {
  source              = "./data"
  location            = azurerm_resource_group.data.location
  resource_group_name = azurerm_resource_group.data.name
  env                 = var.env
  sqldbusername       = var.sqldbusername
  sqldbpassword       = var.sqldbpassword
  sqlservername       = var.sqlservername
  sqldbname           = var.sqldbname
}

module "messaging" {
  source                    = "./messaging"
  location                  = azurerm_resource_group.messaging.location
  resource_group_name       = azurerm_resource_group.messaging.name
  env                       = var.env
  servicebus_namespace_name = var.servicebus_namespace_name
}

# Save secrets

# Common
resource "azurerm_key_vault_secret" "appinsights" {
  name         = "APPINSIGHTSKEY"
  value        = module.common.ai_instrumentation_key
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "kvidentity_id" {
  name         = "KVIDENTITYID"
  value        = module.common.kvidentity_id
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "kvidentity_principal_id" {
  name         = "KVIDENTITYPRINCIPALID"
  value        = module.common.kvidentity_principal_id
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "kvidentity_client_id" {
  name         = "KVIDENTITYCLIENTID"
  value        = module.common.kvidentity_client_id
  key_vault_id = module.common.keyvaultid
}

# Data
resource "azurerm_key_vault_secret" "sqldb_connectionstring" {
  name         = "SQLDBCONNECTIONSTRING"
  value        = module.data.sqldb_connectionstring
  key_vault_id = module.common.keyvaultid
}

# Kubernetes
resource "azurerm_key_vault_secret" "nip_hostname"{
  name = "APPHOSTNAME"
  value = module.kubernetes.nip_hostname
  key_vault_id = module.common.keyvaultid
}

# Messaging
resource "azurerm_key_vault_secret" "servicebus_connection_string" {
  name         = "SERVICEBUSCONNECTIONSTRING"
  value        = module.messaging.servicebus_connection_string
  key_vault_id = module.common.keyvaultid
}

# AAD
resource "azurerm_key_vault_secret" "aadclientid"{
  name = "AADCLIENTID"
  value = var.aadclientid
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "aadtenantid"{
  name = "AADTENANTID"
  value = var.aadtenantid
  key_vault_id = module.common.keyvaultid
}

resource "azurerm_key_vault_secret" "aadcientiduri"{
  name = "AADCLIENTIDURI"
  value = var.aadclientiduri
  key_vault_id = module.common.keyvaultid
}
