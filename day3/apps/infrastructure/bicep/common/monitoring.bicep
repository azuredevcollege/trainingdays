@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

@description('Resource tags object to use')
param resourceTag object

param location string = resourceGroup().location

var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'

// ApplicationInsights
resource appi 'Microsoft.Insights/components@2015-05-01' = {
  name: appiName
  location: location
  tags: resourceTag
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}
