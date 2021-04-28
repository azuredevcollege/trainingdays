@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

@description('The SKU of Windows based App Service Plan, default is B1')
@allowed([
  'D1' 
  'F1' 
  'B1' 
  'B2' 
  'B3' 
  'S1' 
  'S2' 
  'S3' 
  'P1' 
  'P2' 
  'P3' 
  'P1V2' 
  'P2V2' 
  'P3V2'
])
param planWindowsSku string = 'B1'

@description('The SKU of Linux based App Service Plan, default is B1')
@allowed([
  'D1' 
  'F1' 
  'B1' 
  'B2' 
  'B3' 
  'S1' 
  'S2' 
  'S3' 
  'P1' 
  'P2' 
  'P3' 
  'P1V2' 
  'P2V2' 
  'P3V2'
])
param planWLinuxSku string = 'B1'

var appiName = 'appi-scm-${env}-${uniqueString(resourceGroup().id)}'
var location = resourceGroup().location
var sbName = 'sb-scm-${env}-${uniqueString(resourceGroup().id)}'
var sbqThumbnail = 'sbq-scm-thumbnails'
var sbtContactsName = 'sbt-contacts'
var sbtContactsSearchSubscription = 'search'
var sbtContactsVisitReportsSubscription = 'visitreports'
var sbtVisitReportsName = 'sbt-visitreports'
var sbtVisitReportsTextAnalyticsSubscription = 'textanalytics'
var cosmosAccount = 'cosmos-scm-${env}-${uniqueString(resourceGroup().id)}'
var planWindowsName = 'plan-scm-win-${env}-${uniqueString(resourceGroup().id)}'
var planLinuxName = 'plan-scm-linux-${env}-${uniqueString(resourceGroup().id)}'
var planDynamicWindowsName = 'plan-scm-win-dyn-${env}-${uniqueString(resourceGroup().id)}'
var stForFunctiontName = 'stfn${env}${take(uniqueString(resourceGroup().id), 11)}'
var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'Common'
}

// ApplicationInsights
resource appi 'Microsoft.Insights/components@2015-05-01' = {
  name: appiName
  location: location
  tags: resourceTag
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

// ServiceBus
resource sb 'Microsoft.ServiceBus/namespaces@2017-04-01' = {
  name: sbName
  location: location
  tags: resourceTag
  sku: {
    name: 'Standard'
    tier:'Standard'
  }
  // Thumbnail Queue
  resource sbqThumbnails 'queues@2017-04-01' = {
    name: sbqThumbnail
    properties: {
      lockDuration: 'PT5M'
      maxSizeInMegabytes: 1024
      requiresDuplicateDetection: false
      requiresSession: false
      defaultMessageTimeToLive: 'P2D'
      deadLetteringOnMessageExpiration: true
      duplicateDetectionHistoryTimeWindow: 'PT10M'
      maxDeliveryCount: 10
      autoDeleteOnIdle: 'P2D'
      enablePartitioning: false
      enableExpress: false
    }
    resource listen 'authorizationRules@2017-04-01' = {
      name: 'listen'
      properties: {
        rights:[
          'Listen'
        ]
      }
    }
    resource send 'authorizationRules@2017-04-01' = {
      name: 'send'
      properties: {
        rights:[
          'Listen'
        ]
      }
    }
  }
  // Contacts Topic
  resource sbtContacts 'topics@2017-04-01' = {
    name: sbtContactsName
    properties: {
      defaultMessageTimeToLive: 'P2D'
      maxSizeInMegabytes: 1024
      requiresDuplicateDetection: false
      duplicateDetectionHistoryTimeWindow: 'PT10M'
      enableBatchedOperations: false
      supportOrdering: false
      autoDeleteOnIdle: 'P2D'
      enablePartitioning: false
      enableExpress: false
    }
    resource listen 'authorizationRules@2017-04-01' = {
      name: 'listen'
      properties: {
        rights:[
          'Listen'
        ]
      }
    }
    resource send 'authorizationRules@2017-04-01' = {
      name: 'send'
      properties: {
        rights:[
          'Listen'
        ]
      }
    }
    resource sbtSearchSubscription 'subscriptions@2017-04-01' = {
      name: sbtContactsSearchSubscription
      properties: {
        lockDuration: 'PT5M'
        requiresSession: true
        defaultMessageTimeToLive: 'P2D'
        deadLetteringOnMessageExpiration: true
        maxDeliveryCount: 10
        enableBatchedOperations: false
        autoDeleteOnIdle: 'P2D'
      }
    }
    resource sbtVisitReportsSubscription 'subscriptions@2017-04-01' = {
      name: sbtContactsVisitReportsSubscription
      properties: {
        lockDuration: 'PT5M'
        requiresSession: false
        defaultMessageTimeToLive: 'P2D'
        deadLetteringOnMessageExpiration: true
        maxDeliveryCount: 10
        enableBatchedOperations: false
        autoDeleteOnIdle: 'P2D'
      }
    }
  }

  // VisitReports Topic
  resource sbtVisitReports 'topics@2017-04-01' = {
    name: sbtVisitReportsName
    properties: {
      defaultMessageTimeToLive: 'P2D'
      maxSizeInMegabytes: 1024
      requiresDuplicateDetection: false
      duplicateDetectionHistoryTimeWindow: 'PT10M'
      enableBatchedOperations: false
      supportOrdering: false
      autoDeleteOnIdle: 'P2D'
      enablePartitioning: false
      enableExpress: false
    }
    resource listen 'authorizationRules@2017-04-01' = {
      name: 'listen'
      properties: {
        rights:[
          'Listen'
        ]
      }
    }
    resource send 'authorizationRules@2017-04-01' = {
      name: 'send'
      properties: {
        rights:[
          'Listen'
        ]
      }
    }
    resource sbtTextAnalyticsSubscriptio 'subscriptions' = {
        name: sbtVisitReportsTextAnalyticsSubscription
        properties: {
          lockDuration: 'PT5M'
          requiresSession: false
          defaultMessageTimeToLive: 'P2D'
          deadLetteringOnMessageExpiration: true
          maxDeliveryCount: 10
          enableBatchedOperations: false
          autoDeleteOnIdle: 'P2D'
        }
    }
  }
}

// CosmosDB Account
resource cosmos 'Microsoft.DocumentDB/databaseAccounts@2021-03-15' = {
  name: cosmosAccount
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: 'Eventual'
    }
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: resourceGroup().location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
  }
}

// StorageAccount for Azure Functions
resource stgForFunctions 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: stForFunctiontName
  location: location
  tags: resourceTag
  kind: 'StorageV2'
  sku: {
    name:'Standard_LRS'
  }
}

// Windows based App Service Plan
resource planWindows 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: planWindowsName
  location: location
  tags: resourceTag
  sku: {
    name: planWindowsSku
  }
}

// Linux based App Service Plan
resource planLinux 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: planLinuxName
  location: location
  tags: resourceTag
  kind: 'linux'
  sku: {
    name: planWLinuxSku
  }
  properties: {
    reserved: true
  }
}

// Linux based App Service Plan
resource planDynamicWindows 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: planDynamicWindowsName
  location: location
  tags: resourceTag
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
}

output applicationInsightsKey string = appi.properties.InstrumentationKey


