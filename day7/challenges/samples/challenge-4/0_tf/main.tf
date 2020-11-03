provider "azurerm" {
  version = "~> 2.6.0"
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
}
output "appinsights_base64" {
  value = base64encode(module.common.ai_instrumentation_key)
}

# # Data

# output "cosmos_endpoint" {
#   value = module.data.cosmos_endpoint
# }
output "cosmos_endpoint_base64" {
  value = base64encode(module.data.cosmos_endpoint)
}

# output "cosmos_primary_master_key" {
#   value = module.data.cosmos_primary_master_key
# }
output "cosmos_primary_master_key_base64" {
  value = base64encode(module.data.cosmos_primary_master_key)
}

# output "sqldb_connectionstring" {
#   value = module.data.sqldb_connectionstring
# }
output "sqldb_connectionstring_base64" {
  value = base64encode(module.data.sqldb_connectionstring)
}

# output "search_primary_key" {
#   value = module.data.search_primary_key
# }
output "search_primary_key_base64" {
  value = base64encode(module.data.search_primary_key)
}

# output "search_name" {
#   value = module.data.search_name
# }
output "search_name_base64" {
  value = base64encode(module.data.search_name)
}

# output "textanalytics_endpoint" {
#   value = module.data.textanalytics_endpoint
# }
output "textanalytics_endpoint_base64" {
  value = base64encode(module.data.textanalytics_endpoint)
}

# output "textanalytics_key" {
#   value = module.data.textanalytics_key
# }
output "textanalytics_key_base64" {
  value = base64encode(module.data.textanalytics_key)
}

# # Storage

# output "resources_primary_connection_string" {
#   value = module.storage.resources_primary_connection_string
# }
output "resources_primary_connection_string_base64" {
  value = base64encode(module.storage.resources_primary_connection_string)
}

# output "funcs_primary_connection_string" {
#   value = module.storage.funcs_primary_connection_string
# }
output "funcs_primary_connection_string_base64" {
  value = base64encode(module.storage.funcs_primary_connection_string)
}

# # Messaging

# output "thumbnail_listen_connectionstring" {
#   value = module.messaging.thumbnail_listen_connectionstring
# }
output "thumbnail_listen_connectionstring_base64" {
  value = base64encode(module.messaging.thumbnail_listen_connectionstring)
}

# output "thumbnail_send_connectionstring" {
#   value = module.messaging.thumbnail_send_connectionstring
# }
output "thumbnail_send_connectionstring_base64" {
  value = base64encode(module.messaging.thumbnail_send_connectionstring)
}

# output "contacts_listen_connectionstring" {
#   value = module.messaging.contacts_listen_connectionstring
# }
output "contacts_listen_connectionstring_base64" {
  value = base64encode(module.messaging.contacts_listen_connectionstring)
}

# output "contacts_listen_with_entity_connectionstring" {
#   value = module.messaging.contacts_listen_with_entity_connectionstring
# }
output "contacts_listen_with_entity_connectionstring_base64" {
  value = base64encode(module.messaging.contacts_listen_with_entity_connectionstring)
}

# output "contacts_send_connectionstring" {
#   value = module.messaging.contacts_send_connectionstring
# }
output "contacts_send_connectionstring_base64" {
  value = base64encode(module.messaging.contacts_send_connectionstring)
}

# output "visitreports_listen_connectionstring" {
#   value = module.messaging.visitreports_listen_connectionstring
# }
output "visitreports_listen_connectionstring_base64" {
  value = base64encode(module.messaging.visitreports_listen_connectionstring)
}

# output "visitreports_send_connectionstring" {
#   value = module.messaging.visitreports_send_connectionstring
# }
output "visitreports_send_connectionstring_base64" {
  value = base64encode(module.messaging.visitreports_send_connectionstring)
}
