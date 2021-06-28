@minLength(3)
@maxLength(8)
@description('Name of environment')
param env string = 'devd5'

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
param planLinuxSku string = 'B1'

var resourceTag = {
  Environment: env
  Application: 'SCM'
  Component: 'Common'
}

module monitoring 'monitoring.bicep' = {
  name: 'monitoringDeploy'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

module appplans 'appplans.bicep' = {
  name: 'deployAppPlans'
  params: {
    env: env
    resourceTag: resourceTag
    planWindowsSku: planWindowsSku
    planLinuxSku: planLinuxSku
  }
}

module servicebus 'servicebus.bicep' = {
  name: 'deployServiceBus'
  params: {
    env: env
    resourceTag: resourceTag
  }
}

module cosmos 'cosmos.bicep' = {
  name: 'deployCosmosAccount'
  params: {
    env: env
  }
}
