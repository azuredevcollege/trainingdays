@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Azure AD tenant Id')
param aadTenantId string = ''
@description('Azure AD App ID URI')
param aadClientIdUri string = ''

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM-VisitReports'
}

module cosmos 'cosmosdb.bicep' = {
  name: 'deployCosmos'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

module webapp 'webapp.bicep' = {
  name: 'deployWebAppReports'
  params: {
    env: env
    resourceTag: resourceTag
    aadTenantId: aadTenantId
    aadClientIdUri: aadClientIdUri
  }
}

module textanalytics 'textanalytics.bicep' = {
  name: 'deployTextAnalytics'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

module function 'function.bicep' = {
  name: 'deployFunctionTextAnalytics'
  params: {
    env: env
    resourceTag: resourceTag
    textAnalyticsEndpoint: textanalytics.outputs.endpoint
    textAnalyticsKey: textanalytics.outputs.key
  }
}

output visitreportsWebAppName string = webapp.outputs.webAppName
output textanalyticsFunctionName string = function.outputs.functionName
