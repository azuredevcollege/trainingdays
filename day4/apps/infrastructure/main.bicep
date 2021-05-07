@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'dev'

var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
var location = resourceGroup().location
var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'Infra'
}
var serviceBusNamespaceName = 'sb-scm-${env}-${uniqueString(resourceGroup().id)}'
var serviceBusSKU = 'Standard'
var sbThumbnailsQueueName = 'thumbnails'
var sbScmContactTopicName = 'contacts'

resource appi 'Microsoft.Insights/components@2015-05-01' = {
  name: appiName
  location: location
  tags: resourceTag
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2017-04-01' = {
  name: serviceBusNamespaceName
  location: location
  sku: {
    name: serviceBusSKU
  }
}

resource sbThumbnailsQueue 'Microsoft.ServiceBus/namespaces/queues@2017-04-01' = {
  name: '${serviceBusNamespace.name}/${sbThumbnailsQueueName}'
}

resource sbScmContactTopic 'Microsoft.ServiceBus/namespaces/topics@2017-04-01' = {
  name: '${serviceBusNamespace.name}/${sbScmContactTopicName}'
}

output applicationInsightsKey string = appi.properties.InstrumentationKey
