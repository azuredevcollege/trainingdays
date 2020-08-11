provider "azurerm" {
  version = "~> 2.6.0"
  features {
  }
}

# Azure SQL DB

resource "azurerm_sql_server" "sqlsrv" {
  name                         = var.sqlservername
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
  name                = var.sqldbname
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.sqlsrv.name
  create_mode         = "Default"
  edition             = "Standard"
  requested_service_objective_name = "S1"
  max_size_bytes      = 2147483648

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

# outputs

output "sqldb_connectionstring" {
  value       = "Server=tcp:${azurerm_sql_server.sqlsrv.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.sqldb.name};Persist Security Info=False;User ID=${azurerm_sql_server.sqlsrv.administrator_login};Password=${azurerm_sql_server.sqlsrv.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  description = "SQL DB Connection String"
}