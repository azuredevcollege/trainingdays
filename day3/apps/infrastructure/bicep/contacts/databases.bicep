@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

@description('Sql server\'s admin login name')
param sqlUserName string

@secure()
@description('Sql server\'s admin password')
param sqlUserPwd string

@description('Resource tags object to use')
param resourceTag object

param location string = resourceGroup().location

// SQL database server and DB names
var sqlServerName = 'sql-scm-${env}-${uniqueString(resourceGroup().id)}'
var sqlDbName = 'sqldb-scm-contacts-${env}-${uniqueString(resourceGroup().id)}'
// location and tags

resource sqlServer 'Microsoft.Sql/servers@2020-11-01-preview' = {
  name: sqlServerName
  location: location
  tags: resourceTag
  properties: {
    administratorLogin: sqlUserName
    administratorLoginPassword: sqlUserPwd
    version: '12.0'
  }
  resource contactsDb 'databases@2020-11-01-preview' = {
    name: sqlDbName
    location: location
    tags: resourceTag
    sku: {
      name: 'Basic'
      tier: 'Basic'
      capacity: 5
    }
  }
  resource fwRule 'firewallRules@2020-11-01-preview' = {
    name: 'AllowWindowsAzureIps'
    properties: {
      startIpAddress: '0.0.0.0'
      endIpAddress: '0.0.0.0'
    }
  }
}

output connectionString string = 'Server=tcp:${sqlServer.properties.fullyQualifiedDomainName},1433;Initial Catalog=${sqlDbName};Persist Security Info=False;User ID=${sqlServer.properties.administratorLogin};Password=${sqlUserPwd};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'
