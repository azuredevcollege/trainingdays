@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Resource tags object to use')
param resourceTag object = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM-Contacts'
}

@description('The SKU of Windows based App Service Plan, default is B1')
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
param planWindowsSku string = 'B1'

param sqlConnectionString string

// ContactsAPI WebApp
var webAppName = 'app-contactsapi-${env}-${uniqueString(resourceGroup().id)}'
// AppService Plan Windows
var planWindowsName = 'plan-scm-win-${env}-${uniqueString(resourceGroup().id)}'
// ApplicationInsights name

var location = resourceGroup().location

resource appplan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: planWindowsName
  location: location
  sku: {
    name: planWindowsSku
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
      alwaysOn: true
      use32BitWorkerProcess: false
      cors: {
        allowedOrigins: [
          '*'
        ]
      }
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
      ]
      connectionStrings: [
        {
          name: 'DefaultConnectionString'
          connectionString: sqlConnectionString
          type: 'SQLAzure'
        }
      ]
    }
  }
}

output contactsApiWebAppName string = webAppName
