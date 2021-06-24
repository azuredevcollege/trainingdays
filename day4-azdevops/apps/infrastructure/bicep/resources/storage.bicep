@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Resource tags object to use')
param resourceTag object

var stgResourcesName = 'strs${env}${take(uniqueString(resourceGroup().id), 11)}'
var location = resourceGroup().location

resource stgResources 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: stgResourcesName
  location: location
  tags: resourceTag
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

output storageConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${stgResources.name};AccountKey=${listKeys(stgResources.id, stgResources.apiVersion).keys[0].value}'
