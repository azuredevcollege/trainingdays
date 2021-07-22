var location = resourceGroup().location
@description('The name of the ComsosDB Account.')
@minLength(3)
@maxLength(44)
param cosmosDbAccountName string

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' = {
  name: cosmosDbAccountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    databaseAccountOfferType: 'Standard'
    enableAutomaticFailover: true
    publicNetworkAccess: 'Enabled'
  }
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-03-15' = {
  name: '${cosmosDbAccount.name}/AzDCdb'
  location: location
  properties: {
    resource: {
      id: 'AzDCdb'
    }
    options: {
      autoscaleSettings: {
        maxThroughput: 4000
      }
    }
  }
}

resource containerCustomer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-03-15' = {
  name: '${cosmosDbDatabase.name}/customer'
  location: location
  properties: {
    resource: {
      id: 'customer'
      partitionKey: {
        paths: [
          '/customerId'
        ]
        kind: 'Hash'
      }
      indexingPolicy: {
        automatic: true
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/title/?'
          }
          {
            path: '/firstName/?'
          }
          {
            path: '/lastName/?'
          }
          {
            path: '/emailAddress/?'
          }
          {
            path: '/phoneNumber/?'
          }
          {
            path: '/creationDate/?'
          }
          {
            path: '/addresses/*'
          }
        ]
      }
      defaultTtl: -1
    }
  }
}

resource containerProduct 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-03-15' = {
  name: '${cosmosDbDatabase.name}/product'
  location: location
  properties: {
    resource: {
      id: 'product'
      partitionKey: {
        paths: [
          '/categoryId'
        ]
        kind: 'Hash'
      }
      indexingPolicy: {
        automatic: true
        indexingMode: 'consistent'
        includedPaths: [
          {
            path: '/*'
          }
        ]
        excludedPaths: [
          {
            path: '/"_etag"/?'
          }
        ]
      }
      defaultTtl: -1
    }
  }
}

output cosmosDbAccount string = cosmosDbAccount.name
