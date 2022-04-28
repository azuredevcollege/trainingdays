@minLength(5)
@maxLength(8)
@description('Name of environment')
param env string = 'devd3'

@description('The SKU of Windows based App Service Plan, default is B1')
@allowed([
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

@description('Sql server\'s admin login name')
param sqlUserName string

@secure()
@description('Sql server\'s admin password')
param sqlUserPwd string

param location string = resourceGroup().location

module common 'common/commonmain.bicep' = {
  name: 'deployCommon'
  params: {
    env: env
    planWindowsSku: planWindowsSku
    planLinuxSku: planLinuxSku
    location: location
  }
}

module contacts 'contacts/contactsmain.bicep' = {
  name: 'deployContacts'
  params: {
    env: env
    sqlUserName: sqlUserName
    sqlUserPwd: sqlUserPwd
    location: location
  }
  dependsOn:[
    common
  ]
}

module resources 'resources/resourcesmain.bicep' = {
  name: 'deployResources'
  params: {
    env: env
    location: location
  }
  dependsOn:[
    common
  ]
}

module visitreports 'visitreports/visitreportsmain.bicep' = {
  name: 'deployVisitReports'
  params: {
    env: env
  }
  dependsOn: [
    common
  ]
}

module search 'search/searchmain.bicep' = {
  name: 'deploySearch'
  params: {
    env: env
    location: location
  }

  dependsOn: [
    common
  ]
}

module frontend 'frontend/frontendmain.bicep' = {
  name: 'deployFrontend'
  params: {
    env: env
  }

  dependsOn:[
    common
  ]
}
