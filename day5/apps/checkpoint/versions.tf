terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    azuredevops = {
      source = "microsoft/azuredevops"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    null = {
      source = "hashicorp/null"
    }
    random = {
      source = "hashicorp/random"
    }

  }
  required_version = ">= 0.13"

}
