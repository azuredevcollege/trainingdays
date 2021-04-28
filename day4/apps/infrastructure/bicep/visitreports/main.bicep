@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM-VisitReports'
}

module cosmos 'cosmosdb.bicep' = {
  name: 'deployCosmosvr'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

module webapp 'webapp.bicep' = {
  name: 'deployWebAppvr'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

module textanalytics 'textanalytics.bicep' = {
  name: 'deployTextAnalytics'
  params: {
    env: env
    resourceTag: resourceTag
  }
}
