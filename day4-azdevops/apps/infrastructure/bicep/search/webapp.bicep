@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Resource tags object to use')
param resourceTag object

param searchServiceName string
param searchServiceAdminKey string

// ContactsAPI WebApp
var webAppName = 'app-searchapi-${env}-${uniqueString(resourceGroup().id)}'
// AppService Plan Windows
var planWindowsName = 'plan-scm-win-${env}-${uniqueString(resourceGroup().id)}'
// ApplicationInsights name
var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
// RG
var location = resourceGroup().location
// Search
var indexerName = 'scmcontacts'

resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

resource appplan 'Microsoft.Web/serverfarms@2020-12-01' existing = {
  name: planWindowsName
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
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appi.properties.InstrumentationKey
        }
        {
          name: 'ContactSearchOptions__IndexName'
          value: indexerName
        }
        {
          name: 'ContactSearchOptions__ServiceName'
          value: searchServiceName
        }
        {
          name: 'ContactSearchOptions__AdminApiKey'
          value: searchServiceAdminKey
        }
      ]
    }
  }
}

output webappName string = webAppName
