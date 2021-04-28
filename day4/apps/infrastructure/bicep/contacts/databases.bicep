@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd4'

@description('Sql server\'s admin login name')
param sqlUserName string

@secure()
@description('Sql server\'s admin password')
param sqlUserPwd string

@description('Resource tags object to use')
param resourceTag object

// SQL database server and DB names
var sqlServerName = 'sql-scm-${env}-${uniqueString(resourceGroup().id)}'
var sqlDbName = 'sqldb-scm-contacts-${env}-${uniqueString(resourceGroup().id)}'
// location and tags
var location = resourceGroup().location

resource sqlServer 'Microsoft.Sql/servers@2015-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlUserName
    administratorLoginPassword: sqlUserPwd
    version: '12.0'
  }
  resource contactsDb 'databases@2017-03-01-preview' = {
    name: sqlDbName
    location: location
    sku: {
      name: 'Basic'
      tier: 'Basic'
      capacity: 5
    }
  }
  resource fwRule 'firewallRules@2015-05-01-preview' = {
    name: 'AllowWindowsAzureIps'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '0.0.0.0'
    }
  }
}
