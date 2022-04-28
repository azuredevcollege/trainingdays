@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Resource tags object to use')
param resourceTag object

param searchServiceName string
param searchServiceAdminKey string
param location string = resourceGroup().location

var functionName = 'func-searchindexer-${env}-${uniqueString(resourceGroup().id)}'
var planDynamicWindowsName = 'plan-scm-win-dyn-${env}-${uniqueString(resourceGroup().id)}'
var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
var stForFunctiontName = 'stfn${env}${take(uniqueString(resourceGroup().id), 11)}'
var sbName = 'sb-scm-${env}-${uniqueString(resourceGroup().id)}'
var sbtContactsName = 'sbt-contacts'
var indexerName = 'scmcontacts'

var stgForFunctionConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${stgForFunction.name};AccountKey=${listKeys(stgForFunction.id, stgForFunction.apiVersion).keys[0].value}'

resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

resource stgForFunction 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: stForFunctiontName
}

resource planDynamicWindows 'Microsoft.Web/serverfarms@2020-12-01' existing = {
  name: planDynamicWindowsName
}

resource sb 'Microsoft.ServiceBus/namespaces@2017-04-01' existing = {
  name: sbName
}

resource sbtContacts 'Microsoft.ServiceBus/namespaces/topics@2017-04-01' existing = {
  name: '${sbName}/${sbtContactsName}'
}

resource sbtContactsListenRule 'Microsoft.ServiceBus/namespaces/topics/authorizationRules@2017-04-01' existing = {
  name: '${sbtContacts.name}/listen'
}

resource funcapp 'Microsoft.Web/sites@2020-12-01' = {
  name: functionName
  location: location
  tags: resourceTag
  kind: 'functionapp'
  properties: {
    serverFarmId: planDynamicWindows.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      netFrameworkVersion: 'v6.0'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: stgForFunctionConnectionString
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: stgForFunctionConnectionString
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: functionName
        }
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appi.properties.InstrumentationKey
        }
        {
          name: 'ServiceBusConnectionString'
          value: replace(listKeys(sbtContactsListenRule.id, sbtContactsListenRule.apiVersion).primaryConnectionString, 'EntityPath=${sbtContactsName}', '')
        }
        {
          name: 'ContactIndexerOptions__IndexName'
          value: indexerName
        }
        {
          name: 'ContactIndexerOptions__ServiceName'
          value: searchServiceName
        }
        {
          name: 'ContactIndexerOptions__AdminApiKey'
          value: searchServiceAdminKey
        }
      ]
    }
  }
}

output functionName string = functionName
