@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

@description('Resource tags object to use')
param resourceTag object

param location string = resourceGroup().location

var sbName = 'sb-scm-${env}-${uniqueString(resourceGroup().id)}'
var sbqThumbnail = 'sbq-scm-thumbnails'
var sbtContactsName = 'sbt-contacts'
var sbtContactsSearchSubscription = 'contactsearch'
var sbtContactsVisitReportsSubscription = 'visitreports'
var sbtVisitReportsName = 'sbt-visitreports'
var sbtVisitReportsTextAnalyticsSubscription = 'textanalytics'

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
          'Send'
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
          'Send'
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
          'Send'
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
