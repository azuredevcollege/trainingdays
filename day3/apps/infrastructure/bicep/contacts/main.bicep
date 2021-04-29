@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

@description('Sql server\'s admin login name')
param sqlUserName string

@secure()
@description('Sql server\'s admin password')
param sqlUserPwd string

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM-Contacts'
}

module webapp 'webapp.bicep' = {
  name: 'deployWebApp'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

module database 'databases.bicep' = {
  name: 'deployDatabase'
  params: {
    env: env
    resourceTag: resourceTag
    sqlUserName: sqlUserName
    sqlUserPwd: sqlUserPwd
  }
}
