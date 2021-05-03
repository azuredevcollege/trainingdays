@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

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
