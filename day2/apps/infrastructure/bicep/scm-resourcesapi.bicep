@description('The SKU of App Service Plan, default is B1')
@allowed([
  'D1' 
  'F1' 
  'B1' 
  'B2' 
  'B3' 
  'S1' 
  'S2' 
  'S3' 
  'P1' 
  'P2' 
  'P3' 
  'P1V2' 
  'P2V2' 
  'P3V2'
])
param sku string = 'B1'

@description('Use 32bit worker process or not. Some App Service Plan SKUs does only allow 32bit e.g. D1')
param use32bitWorker bool = true

@description('Use alwaysOn for the App Service Pan or not? Some App Service Plan SKUs does not support it e.g. D1')
param alwaysOn bool = true

@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd2'

param location string = resourceGroup().location

var webAppName = 'app-resourcesapi-${env}-${uniqueString(resourceGroup().id)}'
var appPlanResourceApiName = 'plan-resourcesapi-${env}-${uniqueString(resourceGroup().id)}'
var functionName = 'func-imageresizer-${env}-${uniqueString(resourceGroup().id)}'
var appPlanImageResizerName = 'plan-imageresizer-${env}-${uniqueString(resourceGroup().id)}'
var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
var storageAccountName = 'strs${env}${take(uniqueString(resourceGroup().id), 11)}'

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM Resources'
}

var stgConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${stg.name};AccountKey=${listKeys(stg.id, stg.apiVersion).keys[0].value}'

resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

resource stg 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location: location
  tags: resourceTag
  kind: 'StorageV2'
  sku: {
    name:'Standard_LRS'
  }
  properties: {
    allowBlobPublicAccess: true
  }
}

resource appplanapi 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appPlanResourceApiName
  location: location
  tags: resourceTag
  sku: {
    name: sku
  }
}

resource webapp 'Microsoft.Web/sites@2020-12-01' = {
  name: webAppName
  location: location
  tags: resourceTag
  properties: {
    serverFarmId: appplanapi.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      alwaysOn: alwaysOn
      use32BitWorkerProcess: use32bitWorker
      cors: {
        allowedOrigins: [
          '*'
        ]
      }
      appSettings:[
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appi.properties.InstrumentationKey
        }
        {
          name: 'ImageStoreOptions__StorageAccountConnectionString'
          value: stgConnectionString
        }
        {
          name: 'ImageStoreOptions__ImageContainer'
          value: 'rawimages'
        }
        {
          name: 'ImageStoreOptions__ThumbnailContainer'
          value: 'thumbnails'
        }
        {
          name: 'StorageQueueOptions__StorageAccountConnectionString'
          value: stgConnectionString
        }
        {
          name: 'StorageQueueOptions__Queue'
          value: 'thumbnails'
        }
        {
          name: 'StorageQueueOptions__ImageContainer'
          value: 'rawimages'
        }
        {
          name: 'StorageQueueOptions__ThumbnailContainer'
          value: 'thumbnails'
        }
      ]
    }
  }
}

resource appplanfunc 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appPlanImageResizerName
  location: location
  tags: resourceTag
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
}

resource funcapp 'Microsoft.Web/sites@2020-12-01' = {
  name: functionName
  location: location
  tags: resourceTag
  kind: 'functionapp'
  properties: {
    serverFarmId: appplanfunc.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      appSettings:[
        {
          name: 'AzureWebJobsStorage'
          value: stgConnectionString
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: stgConnectionString
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
          name: 'StorageAccountConnectionString'
          value: stgConnectionString
        }
        {
          name: 'QueueName'
          value: 'thumbnails'
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
          name: 'ImageProcessorOptions__StorageAccountConnectionString'
          value: stgConnectionString
        }
        {
          name: 'ImageProcessorOptions__ImageWidth'
          value: '100'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appi.properties.InstrumentationKey
        }
      ]
    }
  }
}

output resourcesApiEndpoint string = '${webAppName}.azurewebsites.net'
output resourceApiWebAppName string = webAppName
output imageResizerFunctionName string = functionName
