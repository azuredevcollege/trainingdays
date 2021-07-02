# Deploy to Azure WebApp using GitHub Actions

⏲️ _est. time to complete: 30 min._ ⏲️

## here is what you will learn 🎯

in this challenge you will learn how to:

- access your Azure Subscription from GitHub Actions
- use GitHub Secrets to securely store access credentials
- create a Service Principal for your Azure Subscription
- create a Resource Group in GitHub Actions
- deploy a bicep template using GitHub Actions
- build and deploy your WebApp to Azure AppService

## Azure Login Action

```yaml
# az-login.yaml
name: Display Account Info

on:
  push:

env:
  RESOURCE_GROUP_NAME: github-action-bicep-rg
  RESOURCE_GROUP_LOCATION: westeurope
  ENV_NAME: github-action

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - name: Azure Login
        uses: Azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Display Azure account info
        run: az account show -o yaml
```

## Create Service Principal

```shell
az ad sp create-for-rbac --name "{name}-github-actions-sp" --sdk-auth --role contributor --scopes /subscriptions/{subscription-id}
```

## Create Azure Bicep template

```bicep
@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'webapp'

@description('Resource tags object to use')
param resourceTag object = {
  Environment: env
  Application: 'Webapp'
}

@description('The SKU of App Service Plan, default is B2')
@allowed([
  'D1'
  'F1'
  'B1'
  'B2'
  'B3'
  'S1'
  'S2'
  'S3'
  'P1'
  'P2'
  'P3'
  'P1V2'
  'P2V2'
  'P3V2'
])
param planSku string = 'B1'

var webAppName = 'app-webapp-${env}-${uniqueString(resourceGroup().id)}'
var planName = 'plan-webapp-${env}-${uniqueString(resourceGroup().id)}'

var location = resourceGroup().location

resource appplan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: planName
  location: location
  kind: 'linux'
  sku: {
    name: planSku
  }
  properties: {
    reserved: true
  }
}

resource webapp 'Microsoft.Web/sites@2020-12-01' = {
  name: webAppName
  location: location
  tags: resourceTag
  kind: 'app,linux'
  properties: {
    serverFarmId: appplan.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      linuxFxVersion: 'NODE|14-lts'
      alwaysOn: true
    }
  }
}

output webAppName string = webAppName
output webAppEndpoint string = webapp.properties.defaultHostName


```

## Create resource group and deploy Bicep template

```yaml
name: Deploy Bicep template

on:
  push:

env:
  RESOURCE_GROUP_NAME: github-action-bicep-rg
  RESOURCE_GROUP_LOCATION: westeurope
  ENV_NAME: devd4

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v2

      - name: Azure Login
        uses: Azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}

      - name: Create Resource Group
        run: >
          az group create
          -l ${{ env.RESOURCE_GROUP_LOCATION }}
          -n ${{ env.RESOURCE_GROUP_NAME }}

      - name: Deploy Bicep template
        uses: azure/arm-deploy@v1
        id: infra
        with:
          resourceGroupName: ${{ env.RESOURCE_GROUP_NAME }}
          template: ./infra.bicep
          parameters: >
            env=${{ env.ENV_NAME }}

      - name: Print WebApp endpoint
        run: echo ${{steps.infra.outputs.webAppEndpoint }}
```

## Create a simple express app

```shell
npx express-generator ./ --view pug --git
```

## Deploy AppService

```yaml

```
