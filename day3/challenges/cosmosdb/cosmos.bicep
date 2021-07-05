var functionName = 'func-changefeed-${uniqueString(resourceGroup().id)}'
var location = resourceGroup().location
var stForFunctiontName = 'stfn${take(uniqueString(resourceGroup().id), 11)}'
var stgForFunctionConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${stgForFunctions.name};AccountKey=${listKeys(stgForFunctions.id, stgForFunctions.apiVersion).keys[0].value}'
var planLinuxName = 'plan-scm-linux-${uniqueString(resourceGroup().id)}'
param planLinuxSku string = 'B1'

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' = {
  name: uniqueString(resourceGroup().name)
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

// StorageAccount for Azure Functions
resource stgForFunctions 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: stForFunctiontName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource changefeedConsumer 'Microsoft.Web/sites@2020-12-01' = {
  name: functionName
  location: location
  kind: 'functionapp,linux'
  properties: {
    serverFarmId: planLinux.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      alwaysOn: true
      linuxFxVersion: 'NODE|12-lts'
      nodeVersion: '12-lts'
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: stgForFunctionConnectionString
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'node'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'COSMOSDB'
          value: cosmosDbAccount.properties.documentEndpoint
        }
        {
          name: 'COSMOSKEY'
          value: listKeys(cosmosDbAccount.id, cosmosDbAccount.apiVersion).primaryMasterKey
        }
      ]
    }
  }
}

// Linux based App Service Plan
resource planLinux 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: planLinuxName
  location: location
  kind: 'linux'
  sku: {
    name: planLinuxSku
  }
  properties: {
    reserved: true
  }
}

// resource containerCustomerView 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-03-15' = {
//   name: '${cosmosDbDatabase.name}/customerView'
//   location: resourceGroup().location
//   properties: {
//     resource: {
//       id: 'customerView'
//       partitionKey: {
//         paths: [
//           '/area'
//         ]
//         kind: 'Hash'
//       }
//       indexingPolicy: {
//         automatic: true
//         indexingMode: 'consistent'
//         includedPaths: [
//           {
//             path: '/*'
//           }
//         ]
//         excludedPaths: [
//           {
//             path: '/"_etag"/?'
//           }
//         ]
//       }
//       defaultTtl: -1
//     }
//   }
// }

output cosmosDbAccount string = cosmosDbAccount.name
