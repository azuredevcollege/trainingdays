@description('The SKU of App Service Plan, default is B1')
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
param sku string = 'B1'

@description('Use 32bit worker process or not. Some App Service Plan SKUs does only allow 32bit e.g. D1')
param use32bitWorker bool = true

@description('Use alwaysOn for the App Service Pan or not? Some App Service Plan SKUs does not support it e.g. D1')
param alwaysOn bool = true

@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd2'

param location string = resourceGroup().location

var webAppName = 'app-contactsapi-${env}-${uniqueString(resourceGroup().id)}'
var appPlanName = 'plan-contactsapi-${env}-${uniqueString(resourceGroup().id)}'
var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM Contacts'
}

resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

resource appplan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appPlanName
  location: location
  tags: resourceTag
  sku: {
    name: sku
  }
}

resource webapp 'Microsoft.Web/sites@2020-12-01' = {
  name: webAppName
  location: location
  tags: resourceTag
  properties: {
    serverFarmId: appplan.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      alwaysOn: alwaysOn
      use32BitWorkerProcess: use32bitWorker
      cors: {
        allowedOrigins: [
          '*'
        ]
      }
      appSettings:[
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appi.properties.InstrumentationKey
        }
      ]
    }
  }
}

output contactsApiEndpoint string = '${webAppName}.azurewebsites.net'
output contactsApiWebAppName string = webAppName
