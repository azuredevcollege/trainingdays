provider "azurerm" {
  version = "~> 2.49.0"
  features {
  }
}

resource "azurerm_servicebus_namespace" "sbn" {
  name                = "${var.prefix}sbn${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  tags = {
    environment = var.env
    source      = "AzureDevCollege"
  }
}

# Thumbnail Queue

resource "azurerm_servicebus_queue" "queue_thumbnails" {
  name                = "sbq-scm-thumbnails"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sbn.name
}

resource "azurerm_servicebus_queue_authorization_rule" "queue_thumbnails_listen" {
  name                = "thumbnailslisten"
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  queue_name          = azurerm_servicebus_queue.queue_thumbnails.name
  resource_group_name = var.resource_group_name

  listen = true
  send   = false
  manage = false
}

resource "azurerm_servicebus_queue_authorization_rule" "queue_thumbnails_send" {
  name                = "thumbnailssend"
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  queue_name          = azurerm_servicebus_queue.queue_thumbnails.name
  resource_group_name = var.resource_group_name

  listen = false
  send   = true
  manage = false
}

# Contacts Topic

resource "azurerm_servicebus_topic" "contacts" {
  name                = "sbt-contacts"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sbn.name
}

resource "azurerm_servicebus_topic_authorization_rule" "topic_contacts_listen" {
  name                = "scmtopiclisten"
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  topic_name          = azurerm_servicebus_topic.contacts.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_servicebus_topic_authorization_rule" "topic_contacts_send" {
  name                = "scmtopicsend"
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  topic_name          = azurerm_servicebus_topic.contacts.name
  resource_group_name = var.resource_group_name
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_servicebus_subscription" "contacts_search" {
  name                = "contactsearch"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  topic_name          = azurerm_servicebus_topic.contacts.name
  max_delivery_count  = 10
  requires_session    = true
}

resource "azurerm_servicebus_subscription" "contacts_visitreport" {
  name                = "visitreports"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  topic_name          = azurerm_servicebus_topic.contacts.name
  max_delivery_count  = 10
  requires_session    = false
}

# Contacts Topic

resource "azurerm_servicebus_topic" "visitreports" {
  name                = "sbt-visitreports"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sbn.name
}

resource "azurerm_servicebus_topic_authorization_rule" "topic_visitreports_listen" {
  name                = "scmvrtopiclisten"
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  topic_name          = azurerm_servicebus_topic.visitreports.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_servicebus_topic_authorization_rule" "topic_visitreports_send" {
  name                = "scmvrtopicsend"
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  topic_name          = azurerm_servicebus_topic.visitreports.name
  resource_group_name = var.resource_group_name
  listen              = false
  send                = true
  manage              = false
}

resource "azurerm_servicebus_subscription" "visitreports_textanalytics" {
  name                = "textanalytics"
  resource_group_name = var.resource_group_name
  namespace_name      = azurerm_servicebus_namespace.sbn.name
  topic_name          = azurerm_servicebus_topic.visitreports.name
  max_delivery_count  = 10
  requires_session    = false
}

# Outputs

output "thumbnail_listen_connectionstring" {
  value = "Endpoint=sb://${azurerm_servicebus_namespace.sbn.name}.servicebus.windows.net/;SharedAccessKeyName=${azurerm_servicebus_queue_authorization_rule.queue_thumbnails_listen.name};SharedAccessKey=${azurerm_servicebus_queue_authorization_rule.queue_thumbnails_listen.primary_key}"
}

output "thumbnail_send_connectionstring" {
  value = azurerm_servicebus_queue_authorization_rule.queue_thumbnails_send.primary_connection_string
}

output "contacts_send_connectionstring" {
  value = azurerm_servicebus_topic_authorization_rule.topic_contacts_send.primary_connection_string
}

output "contacts_listen_with_entity_connectionstring" {
  value = azurerm_servicebus_topic_authorization_rule.topic_contacts_listen.primary_connection_string
}

output "contacts_listen_connectionstring" {
  value = "Endpoint=sb://${azurerm_servicebus_namespace.sbn.name}.servicebus.windows.net/;SharedAccessKeyName=${azurerm_servicebus_topic_authorization_rule.topic_contacts_listen.name};SharedAccessKey=${azurerm_servicebus_topic_authorization_rule.topic_contacts_listen.primary_key}"
}

output "visitreports_send_connectionstring" {
  value = azurerm_servicebus_topic_authorization_rule.topic_visitreports_send.primary_connection_string
}

output "visitreports_listen_connectionstring_old" {
  value = azurerm_servicebus_topic_authorization_rule.topic_visitreports_listen.primary_connection_string
}

output "visitreports_listen_connectionstring" {
  value = "Endpoint=sb://${azurerm_servicebus_namespace.sbn.name}.servicebus.windows.net/;SharedAccessKeyName=${azurerm_servicebus_topic_authorization_rule.topic_visitreports_listen.name};SharedAccessKey=${azurerm_servicebus_topic_authorization_rule.topic_visitreports_listen.primary_key}"
}
