data "azurerm_kubernetes_service_versions" "current" {
  location       = var.location
  version_prefix = "1.17"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.prefix}k8s${var.env}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}k8s${var.env}"
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "Standard"
  }

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version

  tags = {
    environment = var.env
  }
}

provider "kubernetes" {
  load_config_file = "false"
  host             = azurerm_kubernetes_cluster.k8s.fqdn
  client_certificate = base64decode(
    azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate,
  )
  client_key = base64decode(azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(
    azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate,
  )
}

resource "kubernetes_namespace" "appns" {
  metadata {
    name = "contactsapp"
  }
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "azurerm_public_ip" "ingress_ip" {
  name                = "${var.prefix}ingressip${var.env}"
  location            = var.location
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

provider "helm" {
  kubernetes {
    load_config_file = false
    host             = azurerm_kubernetes_cluster.k8s.kube_config[0].host
    client_certificate = base64decode(
      azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate,
    )
    client_key = base64decode(azurerm_kubernetes_cluster.k8s.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(
      azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate,
    )
    config_path = "ensure-that-we-never-read-kube-config-from-home-dir"
  }
}

resource "helm_release" "ingress" {
  name       = "clstr-ingress"
  chart      = "nginx-ingress"
  repository = "https://kubernetes-charts.storage.googleapis.com/"
  namespace  = kubernetes_namespace.ingress.metadata[0].name

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
  set {
    name  = "controller.service.loadBalancerIP"
    value = azurerm_public_ip.ingress_ip.ip_address
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-resource-group"
    value = azurerm_kubernetes_cluster.k8s.node_resource_group
  }
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  version    = "v1.0.4"

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "ingressShim.defaultIssuerName"
    value = "letsencrypt-prod"
  }
  set {
    name  = "ingressShim.defaultIssuerKind"
    value = "ClusterIssuer"
  }
}

output "nip_hostname" {
  value = "${replace(azurerm_public_ip.ingress_ip.ip_address, ".", "-")}.nip.io"
}

