@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Resource tags object to use')
param resourceTag object

var textAnalyticsName = 'cog-textanalytics-${env}-${uniqueString(resourceGroup().id)}'
var location = resourceGroup().location

resource textAnalytics 'Microsoft.CognitiveServices/accounts@2017-04-18' = {
  name: textAnalyticsName
  tags: resourceTag
  location: location
  kind: 'TextAnalytics'
  sku: {
    name: 'S'
  }
  properties: {
    customSubDomainName: textAnalyticsName
  }
}

output endpoint string = textAnalytics.properties.endpoint
output key string = listKeys(textAnalytics.id, textAnalytics.apiVersion).key1
