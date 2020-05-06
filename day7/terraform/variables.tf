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
