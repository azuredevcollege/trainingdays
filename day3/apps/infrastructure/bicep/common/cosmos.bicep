@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

@description('Resource tags object to use')
param resourceTag object

var cosmosAccount = 'cosmos-scm-${env}-${uniqueString(resourceGroup().id)}'
var location = resourceGroup().location

// CosmosDB Account
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' = {
  name: cosmosAccount
  location: location
  tags: resourceTag
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Eventual'
    }
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: resourceGroup().location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
  }
}
