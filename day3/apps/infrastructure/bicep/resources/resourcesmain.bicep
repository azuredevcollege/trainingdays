@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

param location string = resourceGroup().location

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
    location: location
  }
}

module webapp 'webapp.bicep' = {
  name: 'deployWebAppResources'
  params: {
    env: env
    resourceTag: resourceTag
    storageConnectionString: storage.outputs.storageConnectionString
    location: location
  }
}

module function 'function.bicep' = {
  name: 'deployFunctionResources'
  params: {
    env: env
    resourceTag: resourceTag
    storageConnectionString: storage.outputs.storageConnectionString
    location: location
  }
}

output resourceApiWebAppName string = webapp.outputs.webappName
output imageResizerFunctionName string = function.outputs.functionName
