@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

var cosmosAccount = 'cosmos-scm-${env}-${uniqueString(resourceGroup().id)}'
var cosmosDbName = 'scmvisitreports'
var cosmosDbContainerName = 'visitreports'

resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' existing = {
  name: cosmosAccount
}

resource cosmosDb 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-03-15' = {
  name: '${cosmos.name}/${cosmosDbName}'
  properties: {
    resource: {
      id: cosmosDbName
    }
    options: {
      throughput: 400
    }
  }

  resource container 'containers@2021-03-15' = {
    name: cosmosDbContainerName
    properties: {
      resource: {
        id: cosmosDbContainerName
        partitionKey: {
          paths: [
            '/type'
          ]
          kind: 'Hash'
        }
        indexingPolicy: {
          indexingMode: 'consistent'
          includedPaths: [
            {
              path: '/*'
            }
          ]
        }
      }
    }
  }
}
