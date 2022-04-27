@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd2'
param location string = resourceGroup().location

var storageAccountName = 'stfe${env}${take(uniqueString(resourceGroup().id), 11)}'

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM Frontend'
}

var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
var contactsApiName = 'app-contactsapi-${env}-${uniqueString(resourceGroup().id)}'
var resourcesApiName = 'app-resourcesapi-${env}-${uniqueString(resourceGroup().id)}'

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  tags: resourceTag
  kind: 'StorageV2'
  sku: {
    name:'Standard_LRS'
  }
  properties: {
    accessTier: 'Hot'
  }
}

resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

output applicationInsightsKey string = appi.properties.InstrumentationKey
output contactsApiEndpoint string = 'https://${contactsApiName}.azurewebsites.net'
output resourcesApiEndpoint string = 'https://${resourcesApiName}.azurewebsites.net'
output storageAccountName string = storageAccountName
output storageAccountWebEndpoint string = stg.properties.primaryEndpoints.web
