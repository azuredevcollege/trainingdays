@description('Use 32bit worker process or not. Some App Service Plan SKUs does only allow 32bit e.g. D1')
param use32bitWorker bool = true

@description('Use alwaysOn for the App Service Pan or not? Some App Service Plan SKUs does not support it e.g. D1')
param alwaysOn bool = true

@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

var webAppName = 'app-resourcesapi-${env}-${uniqueString(resourceGroup().id)}'
var planWindowsName = 'plan-scm-win-${env}-${uniqueString(resourceGroup().id)}'
var functionName = 'func-imageresizer-${env}-${uniqueString(resourceGroup().id)}'
var planDynamicWindowsName = 'plan-scm-win-dyn-${env}-${uniqueString(resourceGroup().id)}'
var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
var stForFunctiontName = 'stfn${env}${take(uniqueString(resourceGroup().id), 11)}'
var stgResourcesName = 'strs${env}${take(uniqueString(resourceGroup().id), 11)}'
var sbName = 'sb-scm-${env}-${uniqueString(resourceGroup().id)}'
var sbqThumbnailsName = 'sbq-scm-thumbnails'
var location = resourceGroup().location

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM Resources'
}

var stgForFunctionConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${stgForFunction.name};AccountKey=${listKeys(stgForFunction.id, stgForFunction.apiVersion).keys[0].value}'
var stgResourcesConnectionString = 'DefaultEndpointsProtocol=https;AccountName=${stgResources.name};AccountKey=${listKeys(stgResources.id, stgResources.apiVersion).keys[0].value}'

resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

resource stgForFunction 'Microsoft.Storage/storageAccounts@2021-02-01' existing = {
  name: stForFunctiontName
}

resource planWindows 'Microsoft.Web/serverfarms@2020-12-01' existing = {
  name: planWindowsName
}

resource planDynamicWindows 'Microsoft.Web/serverfarms@2020-12-01' existing = {
  name: planDynamicWindowsName
}

resource sb 'Microsoft.ServiceBus/namespaces@2017-04-01' existing = {
  name: sbName
}

resource sbqThumbnails 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' existing = {
  name: '${sb.name}/${sbqThumbnailsName}'
}

resource sbqThumbnailsListenRule 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2017-04-01' existing = {
  name: '${sbqThumbnails.name}/listen'
}

resource sbqThumbnailsSendRule 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2017-04-01' existing = {
  name: '${sbqThumbnails.name}/send'
}

resource stgResources 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: stgResourcesName
  location: location
  tags: resourceTag
  kind: 'StorageV2'
  sku: {
    name:'Standard_LRS'
  }
}

resource webapp 'Microsoft.Web/sites@2020-12-01' = {
  name: webAppName
  location: location
  tags: resourceTag
  properties: {
    serverFarmId: planWindows.id
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
          value: stgResourcesConnectionString
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
          name: 'ServiceBusQueueOptions__ThumbnailQueueConnectionString'
          value: listKeys(sbqThumbnailsSendRule.id, sbqThumbnailsSendRule.apiVersion).primaryConnectionString
        }
        {
          name: 'StorageQueueOptions__Queue'
          value: 'thumbnails'
        }
        {
          name: 'ServiceBusOptions__ImageContainer'
          value: 'rawimages'
        }
        {
          name: 'ServiceBusOptions__ThumbnailContainer'
          value: 'thumbnails'
        }
      ]
    }
  }
}

resource funcapp 'Microsoft.Web/sites@2020-12-01' = {
  name: functionName
  location: location
  tags: resourceTag
  kind: 'functionapp'
  properties: {
    serverFarmId: planDynamicWindows.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      appSettings:[
        {
          name: 'AzureWebJobsStorage'
          value: stgForFunctionConnectionString
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: stgForFunctionConnectionString
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
          name: 'ServiceBusConnectionString'
          value: listKeys(sbqThumbnailsListenRule.id, sbqThumbnailsListenRule.apiVersion).primaryConnectionString
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
          value: '~3'
        }
        {
          name: 'ImageProcessorOptions__StorageAccountConnectionString'
          value: stgResourcesConnectionString
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
