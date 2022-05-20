@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Resource tags object to use')
param resourceTag object

param sqlConnectionString string
param location string = resourceGroup().location

// ContactsAPI WebApp
var webAppName = 'app-contactsapi-${env}-${uniqueString(resourceGroup().id)}'
// AppService Plan Windows
var planWindowsName = 'plan-scm-win-${env}-${uniqueString(resourceGroup().id)}'
// ApplicationInsights name
var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
// ServiceBus names
var sbName = 'sb-scm-${env}-${uniqueString(resourceGroup().id)}'
var sbtContactsName = 'sbt-contacts'


resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

resource sb 'Microsoft.ServiceBus/namespaces@2017-04-01' existing = {
  name: sbName
}

resource sbtContacts 'Microsoft.ServiceBus/namespaces/topics@2017-04-01' existing = {
  name: '${sb.name}/${sbtContactsName}'
}

resource sbtContactsSendRule 'Microsoft.ServiceBus/namespaces/topics/authorizationRules@2017-04-01' existing = {
  name: '${sbtContacts.name}/send'
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
          name: 'EventServiceOptions__ServiceBusConnectionString'
          value: listKeys(sbtContactsSendRule.id, sbtContactsSendRule.apiVersion).primaryConnectionString
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
