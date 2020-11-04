# CosmosDB

resource "azurerm_cosmosdb_account" "cda" {
  name                = "${var.prefix}cda${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = {
    environment = var.env
  }
}

resource "azurerm_cosmosdb_sql_database" "cda_database" {
  name                = var.cosmosdbname
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cda.name
  throughput          = 400
}

resource "azurerm_cosmosdb_sql_container" "cda_database_container" {
  name                = var.cosmoscontainername
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cda.name
  database_name       = azurerm_cosmosdb_sql_database.cda_database.name
  partition_key_path  = "/type"
}

# Azure SQL DB

resource "azurerm_sql_server" "sqlsrv" {
  name                         = "${var.prefix}sqlsrv${var.env}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.sqldbusername
  administrator_login_password = var.sqldbpassword

  tags = {
    environment = var.env
  }
}

resource "azurerm_sql_database" "sqldb" {
  name                             = "${var.prefix}sqldb${var.env}"
  resource_group_name              = var.resource_group_name
  location                         = var.location
  server_name                      = azurerm_sql_server.sqlsrv.name
  requested_service_objective_name = "S0"
  edition                          = "Standard"
  tags = {
    environment = var.env
  }
}

resource "azurerm_sql_firewall_rule" "sqldb" {
  name                = "FirewallRule1"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sqlsrv.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

# SEARCH

resource "azurerm_search_service" "search" {
  name                = "${var.prefix}search${var.env}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "standard"

  tags = {
    environment = var.env
  }
}

# Cognitive Services

resource "azurerm_cognitive_account" "textanalytics" {
  name                = "${var.prefix}cognitive${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "TextAnalytics"

  sku_name = "S0"

  tags = {
    environment = var.env
  }
}

output "cosmos_endpoint" {
  value       = azurerm_cosmosdb_account.cda.endpoint
  description = "Cosmo DB Endpoint"
}

output "cosmos_primary_master_key" {
  value       = azurerm_cosmosdb_account.cda.primary_master_key
  description = "Cosmo DB Primary Master key"
}

output "cosmos_secondary_master_key" {
  value       = azurerm_cosmosdb_account.cda.secondary_master_key
  description = "Cosmo DB Primary Master key"
}

output "sqldb_connectionstring" {
  value       = "Server=tcp:${azurerm_sql_server.sqlsrv.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.sqldb.name};Persist Security Info=False;User ID=${azurerm_sql_server.sqlsrv.administrator_login};Password=${azurerm_sql_server.sqlsrv.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  description = "SQL DB Connection String"
}

output "search_primary_key" {
  value       = azurerm_search_service.search.primary_key
  description = "Search Primary Key"
}

output "search_name" {
  value       = azurerm_search_service.search.name
  description = "Search Name"
}

output "textanalytics_endpoint" {
  value = azurerm_cognitive_account.textanalytics.endpoint
}

output "textanalytics_key" {
  value = azurerm_cognitive_account.textanalytics.primary_access_key
}

