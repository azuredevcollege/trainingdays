provider "azurerm" {
  version = "~> 2.6.0"
  features {}
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.prefix}k8s${var.env}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  dns_prefix          = "${var.prefix}k8s${var.env}"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "${var.env}"
  }
}
