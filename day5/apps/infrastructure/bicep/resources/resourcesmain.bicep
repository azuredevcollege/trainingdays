@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd5'

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
  Component: 'SCM-Resources'
}

module storage 'storage.bicep' = {
  name: 'deployStorageResources'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

module webapp 'webapp.bicep' = {
  name: 'deployWebAppResources'
  params: {
    env: env
    resourceTag: resourceTag
    storageConnectionString: storage.outputs.storageConnectionString
    aadInstance: aadInstance
    aadDomain: aadDomain
    aadTenantId: aadTenantId
    aadClientId: aadClientId
    aadClientIdUri: aadClientIdUri
  }
}

module function 'function.bicep' = {
  name: 'deployFunctionResources'
  params: {
    env: env
    resourceTag: resourceTag
    storageConnectionString: storage.outputs.storageConnectionString
  }
}

output resourceApiWebAppName string = webapp.outputs.webappName
output imageResizerFunctionName string = function.outputs.functionName
