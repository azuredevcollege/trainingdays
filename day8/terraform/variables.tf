variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  type    = string
  default = "adcd8"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "app_insights_name" {
  type    = string
  default = "adcd8-dev"
}

variable "keyvault_name" {
  type    = string
  default = "adcd8-dev"
}

variable "keyvault_identity_name" {
  type    = string
  default = "adcd8-dev"
}

variable "aks_cluster_name" {
  type    = string
  default = "adcd8-dev"
}

variable "sqldbusername" {
  type    = string
  default = "adcsqladmin"
}

variable "sqldbpassword" {
  type = string
}

variable "sqlservername" {
  type = string
  default = "adcd8-dev"
}

variable "sqldbname" {
  type = string
  default = "adcd8-contacts-dev"
}

variable "servicebus_namespace_name" {
    type = string
    default = "adcd8-dev"
}

variable "aadtenantid" {
  type = string
  default = "b26f693d-3f41-4f90-b67c-69b1ea396820"
}

variable "aadclientid" {
  type = string
  default = "ed5ba88a-334a-4841-8a8d-f08d36afe8b8"
} 

variable "aadclientiduri" {
  type = string
  default = "http://scmapi-dev"
}

# Azure DevOps
variable "devops_pat" {
    type = string
}

variable "devops_orgurl" {
    type = string
}

variable "devops_projectid" {
    type = string
    default = "44837ab7-f1d6-4ea5-89fe-916ac85b622e"
}

variable "devops_serviceconnectionid" {
    type = string
    default = "da2cb313-30c6-491d-b84b-6951079e414f"
}

variable "devops_keyvaultgroupname" {
    type = string
}
