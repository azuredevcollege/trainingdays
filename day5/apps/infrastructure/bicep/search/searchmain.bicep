@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Azure Active Directory Instance')
param aadInstance string = ''
@description('Azure AD Tenant Id')
param aadTenantId string = ''
@description('Azure Ad App client Id')
param aadClientId string = ''
@description('Azure AD Domain name')
param aadDomain string = ''
@description('Azure AD App URI')
param aadClientIdUri string = ''

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM-Search'
}

module search 'search.bicep' = {
  name: 'deployCognitiveSearch'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

module webapp 'webapp.bicep' = {
  name: 'deployeWebAppSearch'
  params: {
    env: env
    resourceTag: resourceTag
    searchServiceName: search.outputs.name
    searchServiceAdminKey: search.outputs.adminkey
    aadInstance: aadInstance
    aadDomain: aadDomain
    aadTenantId: aadTenantId
    aadClientId: aadClientId
    aadClientIdUri: aadClientIdUri
  }
}

module function 'function.bicep' = {
  name: 'deployFunctionSearchIndexer'
  params: {
    env: env
    resourceTag: resourceTag
    searchServiceName: search.outputs.name
    searchServiceAdminKey: search.outputs.adminkey
  }
}

output searchApiWebAppName string = webapp.outputs.webappName
output indexerFunctionName string = function.outputs.functionName
