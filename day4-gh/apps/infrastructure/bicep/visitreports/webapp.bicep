@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Resource tags object to use')
param resourceTag object

var planLinuxName = 'plan-scm-linux-${env}-${uniqueString(resourceGroup().id)}'
var webAppName = 'app-visitreportsapi-${env}-${uniqueString(resourceGroup().id)}'
var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
var cosmosAccount = 'cosmos-scm-${env}-${uniqueString(resourceGroup().id)}'
var sbName = 'sb-scm-${env}-${uniqueString(resourceGroup().id)}'
var sbtVisitReportsName = 'sbt-visitreports'
var sbtContactsName = 'sbt-contacts'
var sbtContactsVisitReportsSubscription = 'visitreports'
var location = resourceGroup().location

resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' existing = {
  name: cosmosAccount
}

resource planLinux 'Microsoft.Web/serverfarms@2020-12-01' existing = {
  name: planLinuxName
}

resource sb 'Microsoft.ServiceBus/namespaces@2017-04-01' existing = {
  name: sbName
}

resource sbtVisitReports 'Microsoft.ServiceBus/namespaces/topics@2017-04-01' existing = {
  name: '${sb.name}/${sbtVisitReportsName}'
}

resource sbtVisitReportsSendRule 'Microsoft.ServiceBus/namespaces/topics/authorizationRules@2017-04-01' existing = {
  name: '${sbtVisitReports.name}/send'
}

resource sbtContacts 'Microsoft.ServiceBus/namespaces/topics@2017-04-01' existing = {
  name: '${sb.name}/${sbtContactsName}'
}

resource sbtContactsListenRule 'Microsoft.ServiceBus/namespaces/topics/authorizationRules@2017-04-01' existing = {
  name: '${sbtContacts.name}/listen'
}

resource webapp 'Microsoft.Web/sites@2020-12-01' = {
  name: webAppName
  location: location
  tags: resourceTag
  kind: 'app,linux'
  properties: {
    serverFarmId: planLinux.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      alwaysOn: true
      use32BitWorkerProcess: false
      linuxFxVersion: 'NODE|12-lts'
      nodeVersion: '12-lts'
      cors: {
        allowedOrigins: [
          '*'
        ]
      }
      appSettings: [
        {
          name: 'APPINSIGHTS_KEY'
          value: appi.properties.InstrumentationKey
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appi.properties.InstrumentationKey
        }
        {
          name: 'COSMOSDB'
          value: cosmos.properties.documentEndpoint
        }
      ]
      connectionStrings: [
        {
          name: 'COSMOSKEY'
          connectionString: listKeys(cosmos.id, cosmos.apiVersion).primaryMasterKey
          type: 'Custom'
        }
        {
          name: 'SBVRTOPIC_CONNSTR'
          connectionString: listKeys(sbtVisitReportsSendRule.id, sbtVisitReportsSendRule.apiVersion).primaryConnectionString
          type: 'Custom'
        }
        {
          name: 'SBCONTACTSTOPIC_CONNSTR'
          connectionString: listKeys(sbtContactsListenRule.id, sbtContactsListenRule.apiVersion).primaryConnectionString
          type: 'Custom'
        }
      ]
    }
  }
}

output webAppName string = webAppName
