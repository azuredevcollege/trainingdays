variable "location" {
  type = string
}

variable "env" {
  type = string
}

variable "resource_group_name" {
  type = string
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