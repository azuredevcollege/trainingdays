provider "azurerm" {
  version = "~> 2.6.0"
  features {
  }
}

resource "azurerm_servicebus_namespace" "sbn" {
  name                = var.servicebus_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  tags = {
    environment = var.env
  }
}

# Thumbnail Queue

resource "azurerm_servicebus_queue" "queue_thumbnails" {
  name                = "thumbnails"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sbn.name
}

# Contacts Topic
resource "azurerm_servicebus_topic" "contacts" {
  name                = "scmtopic"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sbn.name
}

resource "azurerm_servicebus_subscription" "contacts_search" {
  name                = "scmsearch"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  topic_name          = azurerm_servicebus_topic.contacts.name
  max_delivery_count  = 10
  requires_session    = true
}

resource "azurerm_servicebus_subscription" "contacts_visitreport" {
  name                = "scmvisitreports"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  topic_name          = azurerm_servicebus_topic.contacts.name
  max_delivery_count  = 10
  requires_session    = false
}

output "servicebus_connection_string" {
    value       = azurerm_servicebus_namespace.sbn.default_primary_connection_string
    description = "ServiceBus connection string with RootManagedSharedAccessKey" 
}