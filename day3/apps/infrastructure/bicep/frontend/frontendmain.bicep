@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM-Frontend'
}

module storage 'storage.bicep' = {
  name: 'deployStorageFrontend'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

output applicationInsightsKey string = storage.outputs.applicationInsightsKey
output contactsApiEndpoint string = storage.outputs.contactsApiEndpoint
output resourcesApiEndpoint string = storage.outputs.resourcesApiEndpoint
output searchApiEndpoint string = storage.outputs.searchApiEndpoint
output visitReportsEndpoint string = storage.outputs.visitReportsApiEndpoint
output storageAccountName string = storage.outputs.storageAccountName
output storageAccountWebEndpoint string = storage.outputs.storageAccountWebEndpoint
