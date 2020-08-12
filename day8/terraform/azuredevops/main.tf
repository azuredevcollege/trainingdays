provider "azuredevops" {
  version               = ">= 0.0.1"
  org_service_url       = var.orgurl
  personal_access_token = var.pat
}

resource "azuredevops_variable_group" "kvintegratedvargroup" {
  project_id   = var.projectid
  name         = var.keyvaultgroupname
  description  = "KeyVault integrated Variable Group"
  allow_access = true

  key_vault {
    name                = var.keyvaultname
    service_endpoint_id = var.serviceconnectionid
  }

  dynamic "variable" {
      for_each = var.groupvariables
      content {
          name = variable.value
      }
  }
}
