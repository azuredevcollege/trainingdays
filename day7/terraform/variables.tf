variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  type    = string
  default = "adcday7"
  validation {
    condition     = length(var.prefix) <= 7
    error_message = "The prefix value must not be longer than 7 characters."
  }
}

variable "env" {
  type    = string
  default = "dev"
}

variable "cosmosdbname" {
  type    = string
  default = "scmvisitreports"
}

variable "cosmoscontainername" {
  type    = string
  default = "visitreports"
}

variable "sqldbusername" {
  type    = string
  default = "adcsqladmin"
}

variable "sqldbpassword" {
  type    = string
  default = "Ch@ngeMe!123!"
}

