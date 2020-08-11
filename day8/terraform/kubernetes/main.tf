provider "azurerm" {
  version = "~> 2.6.0"
  features {
  }
}

data "azurerm_client_config" "current" {
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                  = var.aks_cluster_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  dns_prefix            = var.aks_cluster_name
  
  role_based_access_control {
      enabled = true
  }

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

  kubernetes_version = "1.18.4"

  tags = {
    environment = var.env
  }
}

data "azurerm_resource_group" "k8s_node_resource_group" {
  name = azurerm_kubernetes_cluster.k8s.node_resource_group
}

## assign "Managed Identity Operator" role to kubelet identity
resource azurerm_role_assignment "identity_operator" {
    scope                   = var.kvidentity_id
    role_definition_name    = "Managed Identity Operator"
    principal_id            = azurerm_kubernetes_cluster.k8s.kubelet_identity.0.object_id
}

resource azurerm_role_assignment "vm_contributor" {
    scope                   = data.azurerm_resource_group.k8s_node_resource_group.id
    role_definition_name    = "Virtual Machine Contributor"
    principal_id            = azurerm_kubernetes_cluster.k8s.kubelet_identity.0.object_id
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

## aad-pod-identity namespace
resource "kubernetes_namespace" "aad_pod_identity_ns" {
  metadata {
    name = "aad-pod-identity"
  }
}

## App namespace
resource "kubernetes_namespace" "app_ns" {
  metadata {
    name = var.env
  }
}

## dapr namespace
resource "kubernetes_namespace" "dapr_ns" {
    metadata {
        name = "dapr-system"
    }
}
## Ingress namespace
resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress-${var.env}"
  }
}

## Cert-Manager namespace
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

## Public IP to use for LoadBalancer
resource "azurerm_public_ip" "ingress_ip" {
  name                = "${var.aks_cluster_name}ingressip"
  location            = var.location
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}

## helm
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

# install aad-pod-identity
resource "helm_release" "aad_pod_identity" {
  name       = "aad-pod-identity"
  chart      = "aad-pod-identity"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  namespace  = kubernetes_namespace.aad_pod_identity_ns.metadata[0].name

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
      name = "forceNameSpaced"
      value = "true"
  }
}

# install dapr
resource "helm_release" "dapr" {
  name       = "dapr"
  chart      = "dapr"
  repository = "https://daprio.azurecr.io/helm/v1/repo"
  namespace  = kubernetes_namespace.dapr_ns.metadata[0].name
}

## install NGINX ingress
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

  set {
    name = "controller.watchNamespace"
    value = kubernetes_namespace.app_ns.metadata[0].name
  }
}

## Install jetstack Cert-Manager
resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  version    = "v0.15.0"

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
  set {
    name  = "ingressShim.defaultIssuerGroup"
    value = "cert-manager.io"
  }
}

# kubectl provider, experimental state!!!
## https://gavinbunney.github.io/terraform-provider-kubectl/docs/provider.html#install-latest-version
provider "kubectl" {
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

resource "kubectl_manifest" "azureidentity" {
  yaml_body = <<YAML
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentity
metadata:
  namespace: ${var.env}
  name: keyvault-identity
spec:
  type: 0
  resourceID: ${var.kvidentity_id}
  clientID: ${var.kvidentity_client_id}
    YAML

  depends_on = [helm_release.aad_pod_identity]
}

resource "kubectl_manifest" "azureidentitybinding" {
  yaml_body = <<YAML
apiVersion: "aadpodidentity.k8s.io/v1"
kind: AzureIdentityBinding
metadata:
  namespace: ${var.env}
  name: keyvault-identity-binding
spec:
  azureIdentity: keyvault-identity
  selector: keyvault-identity
    YAML

  depends_on = [helm_release.aad_pod_identity]
}

output "nip_hostname" {
  value = "${replace(azurerm_public_ip.ingress_ip.ip_address, ".", "-")}.nip.io"
}