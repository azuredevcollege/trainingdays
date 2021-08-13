provider "azuredevops" {}

locals {
  project_name  = "DevCollegeDay5Restore"
  unique_prefix = var.unique_resource_prefix == "" ? join("", ["a", random_string.prefix.result]) : var.unique_resource_prefix
  branch_name   = data.azuredevops_git_repositories.default.repositories[0].default_branch
}

resource "random_string" "prefix" {
  length  = 5
  special = false
  upper   = false
}

resource "azuredevops_project" "project" {
  name               = local.project_name
  description        = "Restored checkpoint for the dev college trainingdays day 5."
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Basic"

  features = {
    "boards"    = "disabled"
    "testplans" = "disabled"
    "artifacts" = "disabled"
  }
}

data "azuredevops_git_repositories" "default" {
  project_id = azuredevops_project.project.id
  name       = local.project_name
}

provider "null" {}

resource "null_resource" "git_restore" {
  triggers = {
    azuredevops_project_id = azuredevops_project.project.id
  }

  provisioner "local-exec" {
    command = "ssh-keyscan -H ssh.dev.azure.com >> ~/.ssh/known_hosts && git remote add restore ${data.azuredevops_git_repositories.default.repositories[0].ssh_url}; git push restore master && git remote remove restore"
  }
}
resource "random_string" "sql_admin_username" {
  length  = 10
  special = false
}

resource "random_string" "sql_admin_password" {
  length      = 14
  special     = false
  min_numeric = 1
  min_upper   = 1
}

resource "azuredevops_variable_group" "day5_vars" {
  project_id   = azuredevops_project.project.id
  name         = "Day5RestoreCommonVars"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "sqlAdminUser"
    value = random_string.sql_admin_username.result
  }

  variable {
    name  = "sqlAdminPassword"
    value = random_string.sql_admin_password.result
  }

  variable {
    name  = "serviceBusNamespaceName"
    value = "${local.unique_prefix}-adcd5sb-restore"
  }

  variable {
    name  = "cosmosDbAccountName"
    value = "${local.unique_prefix}-adcd5cosmos-restore"
  }
}

resource "azuredevops_variable_group" "aad_vars" {
  project_id   = azuredevops_project.project.id
  name         = "Day5RestoreAADVars"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "AadInstance"
    value = "https://login.microsoftonline.com"
  }

  variable {
    name  = "AadClientId"
    value = ""
  }

  variable {
    name  = "AadTenantId"
    value = ""
  }

  variable {
    name  = "AadDomain"
    value = ""
  }

  variable {
    name  = "AadClientIdUri"
    value = ""
  }

  variable {
    name  = "AadApiClientIdUri"
    value = ""
  }

  variable {
    name  = "AadFrontendClientId"
    value = ""
  }
}
resource "azuredevops_build_definition" "common" {
  project_id = azuredevops_project.project.id
  name       = "SCM Common"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repositories.default.repositories[0].id
    branch_name = local.branch_name
    yml_path    = "/day5/apps/checkpoint/pipelines/cd-scm-common.yaml"
  }

  variable {
    name           = "uniquePrefix"
    value          = local.unique_prefix
    allow_override = false
  }

  variable_groups = [
    azuredevops_variable_group.day5_vars.id,
  ]

  depends_on = [
    null_resource.git_restore,
  ]
}


resource "azuredevops_build_definition" "api" {
  project_id = azuredevops_project.project.id
  name       = "SCM API"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repositories.default.repositories[0].id
    branch_name = local.branch_name
    yml_path    = "/day5/apps/checkpoint/pipelines/cd-scm-api.yaml"
  }

  variable {
    name           = "uniquePrefix"
    value          = local.unique_prefix
    allow_override = false
  }

  variable_groups = [
    azuredevops_variable_group.day5_vars.id,
  ]

  depends_on = [
    null_resource.git_restore,
  ]
}

resource "azuredevops_build_definition" "fe" {
  project_id = azuredevops_project.project.id
  name       = "SCM Frontend"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repositories.default.repositories[0].id
    branch_name = local.branch_name
    yml_path    = "/day5/apps/checkpoint/pipelines/cd-scm-fe.yaml"
  }

  variable {
    name           = "uniquePrefix"
    value          = local.unique_prefix
    allow_override = false
  }

  depends_on = [
    null_resource.git_restore,
  ]
}


resource "azuredevops_build_definition" "resources-api" {
  project_id = azuredevops_project.project.id
  name       = "SCM Resources API"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repositories.default.repositories[0].id
    branch_name = local.branch_name
    yml_path    = "/day5/apps/checkpoint/pipelines/cd-scm-resources.yaml"
  }

  variable {
    name           = "uniquePrefix"
    value          = local.unique_prefix
    allow_override = false
  }

  depends_on = [
    null_resource.git_restore,
  ]
}

resource "azuredevops_build_definition" "search-api" {
  project_id = azuredevops_project.project.id
  name       = "SCM Search API"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repositories.default.repositories[0].id
    branch_name = local.branch_name
    yml_path    = "/day5/apps/checkpoint/pipelines/cd-scm-search.yaml"
  }

  variable {
    name           = "uniquePrefix"
    value          = local.unique_prefix
    allow_override = false
  }

  depends_on = [
    null_resource.git_restore,
  ]
}

resource "azuredevops_build_definition" "visitreports" {
  project_id = azuredevops_project.project.id
  name       = "SCM Visitreports CI"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repositories.default.repositories[0].id
    branch_name = local.branch_name
    yml_path    = "/day5/apps/checkpoint/pipelines/cd-scm-visitreports.yaml"
  }

  variable {
    name           = "uniquePrefix"
    value          = local.unique_prefix
    allow_override = false
  }

  depends_on = [
    null_resource.git_restore,
  ]
}

resource "azuredevops_build_definition" "ta-func" {
  project_id = azuredevops_project.project.id
  name       = "SCM Text Analytics Function"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = data.azuredevops_git_repositories.default.repositories[0].id
    branch_name = local.branch_name
    yml_path    = "/day5/apps/checkpoint/pipelines/cd-scm-textanalytics.yaml"
  }

  variable {
    name           = "uniquePrefix"
    value          = local.unique_prefix
    allow_override = false
  }

  depends_on = [
    null_resource.git_restore,
  ]
}

## Service Principal for DevOps

data "azurerm_subscription" "current" {
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

provider "random" {}

resource "azuread_application" "azdevopssp" {
  display_name = "azdevopsterraform"
}

resource "random_string" "password" {
  length  = 32
  special = true
}

resource "azuread_service_principal" "azdevopssp" {
  application_id = azuread_application.azdevopssp.application_id
}

resource "azuread_service_principal_password" "azdevopssp" {
  service_principal_id = azuread_service_principal.azdevopssp.id
  value                = random_string.password.result
  end_date             = "2024-01-01T00:00:00Z"
}

resource "azurerm_role_assignment" "main" {
  principal_id         = azuread_service_principal.azdevopssp.id
  scope                = "/subscriptions/${data.azurerm_subscription.current.subscription_id}"
  role_definition_name = "Contributor"
}

## Service Connection

resource "azuredevops_serviceendpoint_azurerm" "endpointazure" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "AzureDeveloperCollege"
  credentials {
    serviceprincipalid  = azuread_service_principal.azdevopssp.application_id
    serviceprincipalkey = random_string.password.result
  }
  azurerm_spn_tenantid      = data.azurerm_subscription.current.tenant_id
  azurerm_subscription_id   = data.azurerm_subscription.current.subscription_id
  azurerm_subscription_name = data.azurerm_subscription.current.display_name
}

resource "azurerm_resource_group" "container_rg" {
  name     = "${local.unique_prefix}_adc_registry_rg"
  location = "westeurope"
}

resource "azurerm_container_registry" "acr" {
  name                = "${local.unique_prefix}adcTrainingDaysContainerRegistry"
  resource_group_name = azurerm_resource_group.container_rg.name
  location            = azurerm_resource_group.container_rg.location
  sku                 = "Premium"
  admin_enabled       = true
}

resource "azuredevops_serviceendpoint_dockerregistry" "acr" {
  project_id            = azuredevops_project.project.id
  service_endpoint_name = "ADC-ContainerRegistry"
  docker_registry       = azurerm_container_registry.acr.login_server
  docker_username       = azurerm_container_registry.acr.admin_username
  docker_password       = azurerm_container_registry.acr.admin_password
  registry_type         = "Others"
}
