@description('The name of the ComsosDB Account.')
@minLength(3)
@maxLength(44)
param cosmosDbAccountName string

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' existing = {
  name: cosmosDbAccountName
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-03-15' existing = {
  name: '${cosmosDbAccount.name}/AzDCdb'
}

resource containerCustomerView 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-03-15' = {
  name: '${cosmosDbDatabase.name}/customerView'
  location: resourceGroup().location
  properties: {
    resource: {
      id: 'customerView'
      partitionKey: {
        paths: [
          '/area'
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
