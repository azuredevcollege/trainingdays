@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

var sqlUserName = uniqueString(resourceGroup().id, env, sqlUserPwd)

@secure()
@description('Sql server\'s admin password')
param sqlUserPwd string

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM-Contacts'
}

module database 'databases.bicep' = {
  name: 'deployDatabaseContacts'
  params: {
    env: env
    resourceTag: resourceTag
    sqlUserName: sqlUserName
    sqlUserPwd: sqlUserPwd
  }
}

module webapp 'webapp.bicep' = {
  name: 'deployWebAppContacts'
  params: {
    env: env
    resourceTag: resourceTag
    sqlConnectionString: database.outputs.connectionString
  }
}

output contactsApiWebAppName string = webapp.outputs.contactsApiWebAppName
output sqlUserName string = sqlUserName
