@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

@description('Resource tags object to use')
param resourceTag object

param location string = resourceGroup().location

var searchName = 'srch-scm-${env}-${uniqueString(resourceGroup().id)}'

resource search 'Microsoft.Search/searchServices@2020-08-01' = {
  name: searchName
  location: location
  tags: resourceTag
  sku:{
    name: 'basic'
  }
  properties:{
    replicaCount: 1
    partitionCount: 1
  }
}

output adminkey string = listAdminKeys(search.id, search.apiVersion).primaryKey
output name string = searchName
