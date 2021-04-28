@description('Use 32bit worker process or not. Some App Service Plan SKUs does only allow 32bit e.g. D1')
param use32bitWorker bool = true

@description('Use alwaysOn for the App Service Pan or not? Some App Service Plan SKUs does not support it e.g. D1')
param alwaysOn bool = true

@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

@description('Sql server\'s admin login name')
param sqlUserName string

@secure()
@description('Sql server\'s admin password')
param sqlUserPwd string

// ContactsAPI WebApp
var webAppName = 'app-contactsapi-${env}-${uniqueString(resourceGroup().id)}'
// AppService Plan Windows
var planWindowsName = 'plan-scm-win-${env}-${uniqueString(resourceGroup().id)}'
// ApplicationInsights name
var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
// ServiceBus names
var sbName = 'sb-scm-${env}-${uniqueString(resourceGroup().id)}'
var sbtContactsName = 'sbt-contacts'
// SQL database server and DB names
var sqlServerName = 'sql-scm-${env}-${uniqueString(resourceGroup().id)}'
var sqlDbName = 'sqldb-scm-contacts-${env}-${uniqueString(resourceGroup().id)}'
// location and tags
var location = resourceGroup().location
var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'SCM Contacts'
}

resource appi 'Microsoft.Insights/components@2015-05-01' existing = {
  name: appiName
}

resource sb 'Microsoft.ServiceBus/namespaces@2017-04-01' existing = {
  name: sbName
}

resource sbtContacts 'Microsoft.ServiceBus/namespaces/topics@2017-04-01' existing = {
  name: '${sb.name}/${sbtContactsName}'
}

resource sbtContactsSendRule 'Microsoft.ServiceBus/namespaces/topics/authorizationRules@2017-04-01' existing = {
  name: '${sbtContacts.name}/send'
}

resource appplan 'Microsoft.Web/serverfarms@2020-12-01' existing = {
  name: planWindowsName
}

resource webapp 'Microsoft.Web/sites@2020-12-01' = {
  name: webAppName
  location: location
  tags: resourceTag
  properties: {
    serverFarmId: appplan.id
    httpsOnly: true
    clientAffinityEnabled: false
    siteConfig: {
      alwaysOn: alwaysOn
      use32BitWorkerProcess: use32bitWorker
      cors: {
        allowedOrigins: [
          '*'
        ]
      }
      appSettings:[
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appi.properties.InstrumentationKey
        }
        {
          name: 'EventServiceOptions__ServiceBusConnectionString'
          value: listKeys(sbtContactsSendRule.id, sbtContactsSendRule.apiVersion).primaryConnectionString
        }
      ]
    }
  }
}

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


output contactsApiEndpoint string = '${webAppName}.azurewebsites.net'
output contactsApiWebAppName string = webAppName
