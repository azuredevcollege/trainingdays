@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

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
