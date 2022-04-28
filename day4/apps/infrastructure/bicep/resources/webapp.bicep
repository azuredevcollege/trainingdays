@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Resource tags object to use')
param resourceTag object

@description('Connection string to resource storage')
param storageConnectionString string
param location string = resourceGroup().location

var webAppName = 'app-resourcesapi-${env}-${uniqueString(resourceGroup().id)}'
var planWindowsName = 'plan-scm-win-${env}-${uniqueString(resourceGroup().id)}'
var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
var sbName = 'sb-scm-${env}-${uniqueString(resourceGroup().id)}'
var sbqThumbnailsName = 'sbq-scm-thumbnails'


resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

resource planWindows 'Microsoft.Web/serverfarms@2020-12-01' existing = {
  name: planWindowsName
}

resource sb 'Microsoft.ServiceBus/namespaces@2017-04-01' existing = {
  name: sbName
}

resource sbqThumbnails 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' existing = {
  name: '${sb.name}/${sbqThumbnailsName}'
}

resource sbqThumbnailsSendRule 'Microsoft.ServiceBus/namespaces/queues/authorizationRules@2017-04-01' existing = {
  name: '${sbqThumbnails.name}/send'
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
      alwaysOn: true
      use32BitWorkerProcess: false
      cors: {
        allowedOrigins: [
          '*'
        ]
      }
      appSettings: [
        {
          name: 'WEBSITE_RUN_FROM_PACKAGE'
          value: '1'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appi.properties.InstrumentationKey
        }
        {
          name: 'ImageStoreOptions__StorageAccountConnectionString'
          value: storageConnectionString
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
          name: 'ServiceBusQueueOptions__ImageContainer'
          value: 'rawimages'
        }
        {
          name: 'ServiceBusQueueOptions__ThumbnailContainer'
          value: 'thumbnails'
        }
      ]
    }
  }
}

output webappName string = webAppName
