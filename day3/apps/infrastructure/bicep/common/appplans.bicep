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

@description('Resource tags object to use')
param resourceTag object

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

param location string = resourceGroup().location

var planWindowsName = 'plan-scm-win-${env}-${uniqueString(resourceGroup().id)}'
var planLinuxName = 'plan-scm-linux-${env}-${uniqueString(resourceGroup().id)}'
var planDynamicWindowsName = 'plan-scm-win-dyn-${env}-${uniqueString(resourceGroup().id)}'
var stForFunctiontName = 'stfn${env}${take(uniqueString(resourceGroup().id), 11)}'

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
    name: planLinuxSku
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
