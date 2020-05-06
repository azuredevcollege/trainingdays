variable "location" {
  type    = "string"
  default = "westeurope"
}
variable "prefix" {
  type    = "string"
  default = "adcday7"
}
variable "env" {
  type    = "string"
  default = "dev"
}

variable "cosmosdbname" {
  type    = "string"
  default = "scmvisitreports"
}
variable "cosmoscontainername" {
  type    = "string"
  default = "visitreports"
}

variable "sqldbusername" {
  type    = "string"
  default = "adcsqladmin"
}
variable "sqldbpassword" {
  type    = "string"
  default = "Ch@ngeMe!123!"
}

variable "aaddomain" {
  type    = "string"
  default = "azuredevcollege.onmicrosoft.com"
}
variable "aadtenantid" {
  type    = "string"
  default = "b26f693d-3f41-4f90-b67c-69b1ea396820"
}
variable "aadclientid" {
  type    = "string"
  default = "ed5ba88a-334a-4841-8a8d-f08d36afe8b8"
}
variable "aadclientiduri" {
  type    = "string"
  default = "http://scmapi-dev"
}
