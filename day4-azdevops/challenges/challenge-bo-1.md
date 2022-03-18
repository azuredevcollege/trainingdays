# 💎 Breakout: Create CI/CD Pipelines to deploy the Azure Dev College Sample Application to Azure 💎

## Here is what you will learn 🎯

In this breakout lesson we will deploy the sample application to Azure.

In [Challenge 3](./challenge-3.md), [Challenge 4](./challenge-4.md) and [Challenge 5](./challenge-5.md) you have learned how to create a CI/CD Pipeline to continuously and consistently deploy services to Azure.
You have learned how to use Pull Requests, validation builds and how you track your work with Azure Boards. You may have noticed that there is still some work left to do until the sample application is deployed to your Development and Testing stage.

In this Breakout session we want you to deploy the remaining Microservices to your stages:

- SCM Resource API
- SCM Search API
- SCM Visitreports API
- SCM Textanalytics

As in [Challenge 4](./challenge-4.md) and [Challenge 5](./challenge-5.md) we will perform the following steps for each service:

1. Set the corresponding User Stories to active
2. Create a new feature branch and check it out
3. Create the CI Build definition and validate it
4. Create a the PR validation build
5. Create the CD build for the stages _Development_ and _Testing_
6. Merge the feature branch into the master branch
7. Update your master branch's policies to trigger the PR build to validate a Pull Request
8. Test the build flow
9. Update the SCM-Frontend-CD Release Pipeline, set the missing service endpoint in the variable section and run the pipeline
10. Complete the User Stories

## Table of Contents

1. [SCM Resource API](#scm-resource-api)
2. [SCM Search API](#scm-search-api)
3. [SCM Visitreports API](#scm-visitreports-api)
4. [SCM Textanalytics](#scm-textanalytics)
5. [Test the Application](#test-the-application)
6. [Application Insights](#application-insights)
7. [Congratulation](#congratulation)

## SCM Resource API

This section covers the User Stories **S6** and **S7**.

### Basics

|Name                 | Value |
|---                  | --- |
| _Feature branch_    | features/scmresourceapicicd
| _Projects to build_ | `apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.Api`  <br> <br> `apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.ImageResizer`
| _Project runtime_   | dotnetcore <br> ASP.NET Core <br> AzureFunctions
| _ARM Templates_     | `apps/infrastructure/templates/scm-resources-api-dotnetcore.json`

### Build Data

|Name                          | Value |
|---                           | --- |
| _Build trigger path filters_ | `day4-azdevops/apps/infrastructure/templates/scm-resources-api-dotnetcore.json` <br> <br> `day4-azdevops/apps/dotnetcore/Scm.Resources/\*`
|_CI Build name_               | SCM-Resources-CI
|_PR Build name_               | SCM-Resource-PR
|_CD Build name_               | SCM-Resources-CD

#### CD Build Tasks

- ARM template deployment --> **scm-resources-api-dotnetcore.json**
- Azure App Service Deploy --> **Adc.Scm.Resources.Api.zip**
  - App Service type --> **API App**
  - App Service name --> **$(ApiAppName)**
- Azure App Service deploy --> **Adc.Scm.Resources.ImageResizer.zip**
  - App Service type --> **Function App on Windows**
  - App Service name --> **$(ResizerFunctionName)**

CD Build agent runs on: **Latest Ubuntu version**

#### CD Build Variables - Stage _Development_

| Variable                | Value                                                       | Scope       | ARM Template Parameter  |
| ----------------------- | ----------------------------------------------------------- | ----------- | ----------------------- |
| ResourceGroupName       | ADC-DAY4-SCM-DEV                                            | Development |                         |
| Location                | westeurope                                                  | Development |                         |
| ApiAppName              | **{prefix}**-day4scmresourceapi-dev                         | Development | webAppName              |
| AppServicePlanSKU       | B1                                                          | Development | sku                     |
| Use32BitWorker          | false                                                       | Development | use32bitworker          |
| AlwaysOn                | true                                                        | Development | alwaysOn                |
| StorageAccountName      | **{prefix}** day4resdev (no spaces)                         | Development | storageAccountName      |
| ResizerFunctionName     | **{prefix}**-day4resizer-dev                                | Development | functionAppName         |
| ApplicationInsightsName | your ApplicationInsights instance name of stage Development | Development | applicationInsightsName |
| ServiceBusNamespaceName | your ServiceBus namespace name of stage Development         | Development | serviceBusNamespaceName |

#### CD Build Variables - Stage _Testing_

| Variable                | Value                                                   | Scope   | ARM Template Parameter  |
| ----------------------- | ------------------------------------------------------- | ------- | ----------------------- |
| ResourceGroupName       | ADC-DAY4-SCM-TEST                                       | Testing |                         |
| Location                | westeurope                                              | Testing |                         |
| ApiAppName              | **{prefix}**-day4scmresourcesapi-test                   | Testing | webAppName              |
| AppServicePlanSKU       | B1                                                      | Testing | sku                     |
| Use32BitWorker          | false                                                   | Testing | use32bitworker          |
| AlwaysOn                | true                                                    | Testing | alwaysOn                |
| StorageAccountName      | **{prefix}** day4restest (no spaces)                    | Testing | storageAccountName      |
| ResizerFunctionName     | **{prefix}**-day4resizer-test                           | Testing | functionAppName         |
| ApplicationInsightsName | your ApplicationInsights instance name of stage Testing | Testing | applicationInsightsName |
| ServiceBusNamespaceName | your ServiceBus namespace name of stage Testing         | Testing | serviceBusNamespaceName |

#### CI Build YAML

```yaml
pr: none
trigger:
  branches:
    include:
      - master
  paths:
    include:
      - day4-azdevops/apps/infrastructure/templates/scm-resources-api-dotnetcore.json
      - day4-azdevops/apps/dotnetcore/Scm.Resources/*
jobs:
  - job: Build
    displayName: Build Scm Contacts
    pool:
      vmImage: ubuntu-latest
    steps:
      - task: UseDotNet@2
        displayName: 'Acquire .NET Core Sdk 3.1.x'
        inputs:
          packageType: Sdk
          version: 3.1.x
      - task: DotNetCoreCLI@2
        displayName: Restore
        inputs:
          command: restore
          projects: 'day4-azdevops/apps/dotnetcore/Scm.Resources/**/*.csproj'
      - task: DotNetCoreCLI@2
        displayName: Build
        inputs:
          projects: 'day4-azdevops/apps/dotnetcore/Scm.Resources/**/*.csproj'
          arguments: --configuration Release
      - task: DotNetCoreCLI@2
        displayName: Publish
        inputs:
          command: publish
          publishWebProjects: false
          projects: 'day4-azdevops/apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.Api/Adc.Scm.Resources.Api.csproj'
          arguments: --configuration Release --output $(build.artifactstagingdirectory)
          zipAfterPublish: True
      - task: DotNetCoreCLI@2
        displayName: Publish
        inputs:
          command: publish
          publishWebProjects: false
          projects: 'day4-azdevops/apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.ImageResizer/Adc.Scm.Resources.ImageResizer.csproj'
          arguments: --configuration Release --output $(build.artifactstagingdirectory)
          zipAfterPublish: True
      - task: CopyFiles@2
        inputs:
          sourceFolder: day4-azdevops/apps/infrastructure/templates
          contents: |
            scm-resources-api-dotnetcore.json
          targetFolder: $(Build.ArtifactStagingDirectory)
      - task: PublishPipelineArtifact@1
        inputs:
          targetPath: $(Build.ArtifactStagingDirectory)
          artifactName: drop
```

#### ARM Template Override Parameters

```Shell
-webAppName $(ApiAppName) -sku $(AppServicePlanSKU) -use32bitworker $(Use32BitWorker) -alwaysOn $(AlwaysOn) -storageAccountName $(StorageAccountName) -functionAppName $(ResizerFunctionName) -applicationInsightsName $(ApplicationInsightsName) -serviceBusNamespaceName $(ServiceBusNamespaceName)
```

## SCM Search API

This section covers the User Stories **S8** and **S9**.

### Basics

|Name                 | Value |
|---                  | --- |
| _Feature branch_    | features/scmsearchapicicd*
| _Projects to build_ | `apps/dotnetcore/Scm.Search/Adc.Scm.Search.Api` <br> <br> `apps/dotnetcore/Scm.Search/Adc.Scm.Search.Indexer`
| _Project runtime_   | dotnetcore <br> ASP.NET Core <br> AzureFunctions
| _ARM Templates_     | `apps/infrastructure/templates/scm-search-api-dotnetcore.json`

### Build Data

|Name                          | Value |
|---                           | --- |
| _Build trigger path filters_ | `day4-azdevops/apps/infrastructure/templates/scm-search-api-dotnetcore.json` <br> <br> `day4-azdevops/apps/dotnetcore/Scm.Search/\*`
|_CI Build name_               | SCM-Search-CI
|_PR Build name_               | SCM-Search-PR
|_CD Build name_               | SCM-Search-CD

#### CD Build Tasks

- ARM template deployment --> **scm-search-api-dotnetcore.json**
- Azure App Service Deploy --> **Adc.Scm.Search.Api.zip**
  - App Service type --> **Web App on Windows**
  - App Service name --> **$(ApiAppName)**- Azure App Service Deploy --> **Adc.Scm.Search.Indexer.zip**
  - App Service type --> **Function App on Windows**
  - App Service name --> **$(IndexerFunctionName)**

CD Build agent runs on: **Latest Ubuntu version**

#### CD Build Variables - Stage _Development_

| Variable                  | Value                                                       | Scope       | ARM Template Parameter    |
| ------------------------- | ----------------------------------------------------------- | ----------- | ------------------------- |
| ResourceGroupName         | ADC-DAY4-SCM-DEV                                            | Development |                           |
| Location                  | westeurope                                                  | Development |                           |
| ApiAppName                | **{prefix}**-day4scmsearchapi-dev                           | Development | webAppName                |
| AppServicePlanSKU         | B1                                                          | Development | appPlanSKU                |
| Use32BitWorker            | false                                                       | Development | use32bitworker            |
| AlwaysOn                  | true                                                        | Development | alwaysOn                  |
| StorageAccountName        | **{prefix}** day4srdev (no spaces)                          | Development | storageAccountName        |
| IndexerFunctionName       | **{prefix}**-day4indexer-dev                                | Development | functionAppName           |
| ApplicationInsightsName   | your ApplicationInsights instance name of stage Development | Development | applicationInsightsName   |
| ServiceBusNamespaceName   | your ServiceBus namespace name of stage Development         | Development | serviceBusNamespaceName   |
| AzureSearchServiceName    | **{prefix}**-day4search-dev                                 | Development | azureSearchServiceName    |
| AzureSearchSKU            | basic                                                       | Development | azureSearchSKU            |
| AzureSearchReplicaCount   | 1                                                           | Development | azureSearchReplicaCount   |
| AzureSearchPartitionCount | 1                                                           | Development | azureSearchPartitionCount |

#### CD Build Variables - Stage _Testing_

| Variable                  | Value                                                   | Scope   | ARM Template Parameter    |
| ------------------------- | ------------------------------------------------------- | ------- | ------------------------- |
| ResourceGroupName         | ADC-DAY4-SCM-TEST                                       | Testing |                           |
| Location                  | westeurope                                              | Testing |                           |
| ApiAppName                | **{prefix}**-day4scmsearchapi-dev                       | Testing | webAppName                |
| AppServicePlanSKU         | B1                                                      | Testing | appPlanSKU                |
| Use32BitWorker            | false                                                   | Testing | use32bitworker            |
| AlwaysOn                  | true                                                    | Testing | alwaysOn                  |
| StorageAccountName        | **{prefix}** day4srdev (no spaces)                      | Testing | storageAccountName        |
| IndexerFunctionName       | **{prefix}**-day4indexer-dev                            | Testing | functionAppName           |
| ApplicationInsightsName   | your ApplicationInsights instance name of stage Testing | Testing | applicationInsightsName   |
| ServiceBusNamespaceName   | your ServiceBus namespace name of stage Testing         | Testing | serviceBusNamespaceName   |
| AzureSearchServiceName    | **{prefix}**-day4search-dev                             | Testing | azureSearchServiceName    |
| AzureSearchSKU            | basic                                                   | Testing | azureSearchSKU            |
| AzureSearchReplicaCount   | 1                                                       | Testing | azureSearchReplicaCount   |
| AzureSearchPartitionCount | 1                                                       | Testing | azureSearchPartitionCount |

#### CI Build YAML

```yaml
pr: none
trigger:
  branches:
    include:
      - master
  paths:
    include:
      - day4-azdevops/apps/infrastructure/templates/scm-search-api-dotnetcore.json
      - day4-azdevops/apps/dotnetcore/Scm.Search/*
jobs:
  - job: Build
    displayName: Build Scm Search
    pool:
      vmImage: ubuntu-latest
    steps:
      - task: UseDotNet@2
        displayName: 'Acquire .NET Core Sdk 3.1.x'
        inputs:
          packageType: Sdk
          version: 3.1.x
      - task: DotNetCoreCLI@2
        displayName: Restore
        inputs:
          command: restore
          projects: 'day4-azdevops/apps/dotnetcore/Scm.Search/**/*.csproj'
      - task: DotNetCoreCLI@2
        displayName: Build
        inputs:
          projects: 'day4-azdevops/apps/dotnetcore/Scm.Search/**/*.csproj'
          arguments: --configuration Release
      - task: DotNetCoreCLI@2
        displayName: Publish
        inputs:
          command: publish
          publishWebProjects: false
          projects: 'day4-azdevops/apps/dotnetcore/Scm.Search/Adc.Scm.Search.Api/Adc.Scm.Search.Api.csproj'
          arguments: --configuration Release --output $(build.artifactstagingdirectory)
          zipAfterPublish: True
      - task: DotNetCoreCLI@2
        displayName: Publish
        inputs:
          command: publish
          publishWebProjects: false
          projects: 'day4-azdevops/apps/dotnetcore/Scm.Search/Adc.Scm.Search.Indexer/Adc.Scm.Search.Indexer.csproj'
          arguments: --configuration Release --output $(build.artifactstagingdirectory)
          zipAfterPublish: True
      - task: CopyFiles@2
        inputs:
          sourceFolder: day4-azdevops/apps/infrastructure/templates
          contents: |
            scm-search-api-dotnetcore.json
          targetFolder: $(Build.ArtifactStagingDirectory)
      - task: PublishPipelineArtifact@1
        inputs:
          targetPath: $(Build.ArtifactStagingDirectory)
          artifactName: drop
```

#### ARM Template Override Parameters

```shell
-webAppName $(ApiAppName) -appPlanSKU $(AppServicePlanSKU) -use32bitworker $(Use32BitWorker) -alwaysOn $(AlwaysOn) -storageAccountName $(StorageAccountName) -functionAppName $(IndexerFunctionName) -applicationInsightsName $(ApplicationInsightsName) -serviceBusNamespaceName $(ServiceBusNamespaceName) -azureSearchServiceName $(AzureSearchServiceName) -azureSearchSKU $(AzureSearchSKU) -azureSearchReplicaCount $(AzureSearchReplicaCount) -azureSearchPartitionCount $(AzureSearchPartitionCount)
```

## SCM Visitreports API

This section covers the User Stories **S10** and **S11**.

### Basics

|Name                 | Value |
|---                  | --- |
| _Feature branch_    | features/scmvisitreportscicd
| _Projects to build_ | `apps/nodejs/visitreport`
| _Project runtime_   | Node.js
| _ARM Templates_     | `apps/infrastructure/templates/scm-visitreport-nodejs-db.json` <br> <br> `apps/infrastructure/templates/scm-visitreport-nodejs-infra.json`

:::tip
📝First deploy `scm-visitreport-nodejs-db.json`, then deploy `scm-visitreport-nodejs-infra.json`
:::

### Build Data

|Name                          | Value |
|---                           | --- |
| _Build trigger path filters_ | `day4-azdevops/apps/nodejs/visitreport/\*` <br> <br> `day4-azdevops/apps/infrastructure/templates/scm-visitreport-nodejs-db.json`  <br> <br> `day4-azdevops/apps/infrastructure/templates/scm-visitreport-nodejs-infra.json`
|_CI Build name_               | SCM-Visitreports-CI
|_PR Build name_               | SCM-Visitreports-PR
|_CD Build name_               | SCM-Visitreports-CD

#### CD Build Tasks

- ARM template deployment --> **scm-visitreport-nodejs-db.json**
- ARM template deployment --> **scm-visitreport-nodejs-infra.json**
- Azure App Service deploy --> **Adc.Scm.VisitReports.zip**
  - App Service type --> **Web App on Linux**
  - App Service name --> **$(ApiAppName)**

CD Build agent runs on: **Latest Ubuntu version**

#### CD Build Variables - Stage _Development_

| Variable                    | Value                                                       | Scope       |
| --------------------------- | ----------------------------------------------------------- | ----------- |
| ResourceGroupName           | ADC-DAY4-SCM-DEV                                            | Development |
| ResourceGroupNameTux        | ADC-DAY4-SCM-TUX-DEV                                        | Development |
| Location                    | westeurope                                                  | Development |
| ApiAppName                  | **{prefix}**-day4vsapi-dev                                  | Development |
| AppServicePlanSKU           | Standard                                                    | Development |
| AppServicePlanSKUCode       | S1                                                          | Development |
| ApplicationInsightsName     | your ApplicationInsights instance name of stage Development | Development |
| CosmosDbAccount             | your Cosmos Account Name of stage Development               | Development |
| CosmosDatabaseName          | scmvisitreports                                             | Development |
| CosmosDatabaseContainerName | visitreports                                                | Development |
| ServiceBusNamespaceName     | your ServiceBus namespace name of stage Development         | Development |

#### CD Build Variables - Stage _Testing_

| Variable                    | Value                                                   | Scope   |
| --------------------------- | ------------------------------------------------------- | ------- | --- |
| ResourceGroupName           | ADC-DAY4-SCM-TEST                                       | Testing |
| ResourceGroupNameTux        | ADC-DAY4-SCM-TUX-TEST                                   | Testing |
| Location                    | westeurope                                              | Testing |
| ApiAppName                  | **{prefix}**-day4vsapi-test                             | Testing |
| AppServicePlanSKU           | Standard                                                | Testing |
| AppServicePlanSKUCode       | S1                                                      | Testing |
| ApplicationInsightsName     | your ApplicationInsights instance name of stage Testing | Testing |
| CosmosDbAccount             | your Cosmos Account Name of stage Testing               | Testing |
| CosmosDatabaseName          | scmvisitreports                                         | Testing |
| CosmosDatabaseContainerName | visitreports                                            | Testing | ±±± |
| ServiceBusNamespaceName     | your ServiceBus namespace name of stage Testing         | Testing |

#### Variables to ARM Template Parameters

:::tip
📝Make sure that you apply the ARM Template `scm-visitreport-nodejs-db.json` to ResourceGroup **ResourceGroupName** and
that you apply the ARM Template `scm-visitreport-nodejs-infra.json` to ResourceGroup **ResourceGroupNameTux**
:::

| ARM Template                      | ARM Template Parameter      | Variable to use             | Deploy to ResourceGroup |
| --------------------------------- | --------------------------- | --------------------------- | ----------------------- |
| scm-visitreport-nodejs-db.json    | cosmosDbAccount             | CosmosDbAccount             | ResourceGroupName       |
| scm-visitreport-nodejs-db.json    | cosmosDatabaseName          | CosmosDatabaseName          | ResourceGroupName       |
| scm-visitreport-nodejs-db.json    | cosmosDatabaseContainerName | CosmosDatabaseContainerName | ResourceGroupName       |
| scm-visitreport-nodejs-infra.json | sku                         | AppServicePlanSKU           | ResourceGroupNameTux    |
| scm-visitreport-nodejs-infra.json | skuCode                     | AppServicePlanSKUCode       | ResourceGroupNameTux    |
| scm-visitreport-nodejs-infra.json | webAppName                  | ApiAppName                  | ResourceGroupNameTux    |
| scm-visitreport-nodejs-infra.json | applicationInsightsName     | ApplicationInsightsName     | ResourceGroupNameTux    |
| scm-visitreport-nodejs-infra.json | cosmosDbAccount             | CosmosDbAccount             | ResourceGroupNameTux    |
| scm-visitreport-nodejs-infra.json | serviceBusNamespaceName     | ServiceBusNamespaceName     | ResourceGroupNameTux    |
| scm-visitreport-nodejs-infra.json | commonResGroup              | ResourceGroupName           | ResourceGroupNameTux    |

:::tip
📝 To build a Node.js application you have to install NodeJs on your build agent first. After the installation you can run a bash script that executes `npm install` in your project folder. Next, you can create a zip file and copy it to the artifacts staging directory to publish it in the next step.
:::

#### CI Build YAML

```yaml
pr: none
trigger:
  branches:
    include:
      - master
  paths:
    include:
      - day4-azdevops/apps/nodejs/visitreport/*
      - day4-azdevops/apps/infrastructure/templates/scm-visitreport-nodejs-db.json
      - day4-azdevops/apps/infrastructure/templates/scm-visitreport-nodejs-infra.json
steps:
  - task: NodeTool@0
    inputs:
      versionSpec: '12.x'
    displayName: 'Install Node.js'
  - task: Bash@3
    inputs:
      workingDirectory: '$(Build.SourcesDirectory)/day4-azdevops/apps/nodejs/visitreport'
      targetType: 'inline'
      displayName: 'npm install'
      script: npm install
  - task: ArchiveFiles@2
    displayName: 'Archive build files'
    inputs:
      rootFolderOrFile: '$(Build.SourcesDirectory)/day4-azdevops/apps/nodejs/visitreport'
      includeRootFolder: false
      archiveType: zip
      archiveFile: $(Build.ArtifactStagingDirectory)/Adc.Scm.VisitReports.zip
      replaceExistingArchive: true
  - task: CopyFiles@2
    inputs:
      sourceFolder: day4-azdevops/apps/infrastructure/templates
      contents: |
        scm-visitreport-nodejs-db.json
        scm-visitreport-nodejs-infra.json
      targetFolder: $(Build.ArtifactStagingDirectory)
  - task: PublishPipelineArtifact@1
    inputs:
      targetPath: $(Build.ArtifactStagingDirectory)
      artifactName: drop
```

#### ARM Template Override Parameters

- `scm-visitreport-nodejs-db.json`

  ```shell
  -cosmosDbAccount $(CosmosDbAccount) -cosmosDatabaseName $(CosmosDatabaseName) -cosmosDatabaseContainerName $(CosmosDatabaseContainerName)
  ```

- `scm-visitreport-nodejs-infra.json`

  ```shell
  -sku $(AppServicePlanSKU) -skuCode $(AppServicePlanSKUCode) -webAppName $(ApiAppName) -applicationInsightsName $(ApplicationInsightsName) -cosmosDbAccount $(CosmosDbAccount) -serviceBusNamespaceName $(ServiceBusNamespaceName) -commonResGroup $(ResourceGroupName)
  ```

:::tip
📝 Make sure that your AppService deployment task is configured as follows

![AppService Deployment Task](./images/visitreports-deployment-task.png)

:::

## SCM Textanalytics

This section covers the User Stories **S12** and **S13**.

### Basics

|Name                 | Value |
|---                  | --- |
| _Feature branch_    | features/scmtextanalyticscicd
| _Projects to build_ | `apps/nodejs/textanalytics`
| _Project runtime_   | Node.js
| _ARM Templates_     | `apps/infrastructure/templates/scm-textanalytics-nodejs-common.json` <br> <br> `apps/infrastructure/templates/scm-textanalytics-nodejs-infra.json`

:::tip
📝First deploy `scm-textanalytics-nodejs-common.json`, then deploy `scm-textanalytics-nodejs-infra.json`
:::

### Build Data

|Name                          | Value |
|---                           | --- |
| _Build trigger path filters_ | `day4-azdevops/apps/nodejs/textanalytics/\*` <br> <br> `day4-azdevops/apps/infrastructure/templates/scm-textanalytics-nodejs-common.json`  <br> <br> `day4-azdevops/apps/infrastructure/templates/scm-textanalytics-nodejs-infra.json`
|_CI Build name_               | SCM-Textanalytics-CI
|_PR Build name_               | SCM-Textanalytics-PR
|_CD Build name_               | SCM-Textanalytics-CD

#### CD Build Tasks

- ARM template deployment --> **scm-textanalytics-nodejs-common.json**
- ARM template deployment --> **scm-textanalytics-nodejs-infra.json**
- Azure App Service deploy --> **Adc.Scm.Textanalytics.zip**
  - App Service type --> **Function App on Linux**
  - App Service name: --> **$(FunctionAppName)**

CD Build agent runs on: **Latest Ubuntu version**

#### CD Build Variables - Stage _Development_

| Variable                | Value                                                       | Scope       |
| ----------------------- | ----------------------------------------------------------- | ----------- |
| ResourceGroupName       | ADC-DAY4-SCM-DEV                                            | Development |
| ResourceGroupNameFunc   | ADC-DAY4-SCM-FUNC-DEV                                       | Development |
| Location                | westeurope                                                  | Development |
| TextAnalyticsName       | **{prefix}**-day4cognitive-dev                              | Development |
| TextAnalyticsTier       | S                                                           | Development |
| StorageAccountName      | **{prefix}** day4tadev (no spaces)                          | Development |
| FunctionAppName         | **{prefix}**-day4tafunc-dev                                 | Development |
| ApplicationInsightsName | your ApplicationInsights instance name of stage Development | Development |
| CosmosDbAccount         | your Cosmos Account Name of stage Development               | Development |
| ServiceBusNamespaceName | your ServiceBus namespace name of stage Development         | Development |

#### CD Build Variables - Stage _Testing_

| Variable                | Value                                                   | Scope   |
| ----------------------- | ------------------------------------------------------- | ------- |
| ResourceGroupName       | ADC-DAY4-SCM-TEST                                       | Testing |
| ResourceGroupNameFunc   | ADC-DAY4-SCM-FUNC-TEST                                  | Testing |
| Location                | westeurope                                              | Testing |
| TextAnalyticsName       | **{prefix}**-day4cognitive-test                         | Testing |
| TextAnalyticsTier       | S                                                       | Testing |
| StorageAccountName      | **{prefix}** day4tatest (no spaces)                     | Testing |
| FunctionAppName         | **{prefix}**-day4tafunc-test                            | Testing |
| ApplicationInsightsName | your ApplicationInsights instance name of stage Testing | Testing |
| CosmosDbAccount         | your Cosmos Account Name of stage Testing               | Testing |
| ServiceBusNamespaceName | your ServiceBus namespace name of stage Testing         | Testing |

#### Variables to ARM Template Parameters

:::tip
📝 Make sure that you apply the ARM Template `scm-textanalytics-nodejs-common.json` to ResourceGroup **ResourceGroupName** and
that you apply the ARM Template `scm-textanalytics-nodejs-infra.json` to ResourceGroup **ResourceGroupNameFunc**
:::

| ARM Template                         | ARM Template Parameter  | Variable to use         | Deploy to ResourceGroup |
| ------------------------------------ | ----------------------- | ----------------------- | ----------------------- |
| scm-textanalytics-nodejs-common.json | taname                  | TextAnalyticsName       | ResourceGroupName       |
| scm-textanalytics-nodejs-common.json | tatier                  | TextAnalyticsTier       | ResourceGroupName       |
| scm-textanalytics-nodejs-common.json | storageAccountName      | StorageAccountName      | ResourceGroupName       |
| scm-textanalytics-nodejs-infra.json  | functionAppName         | FunctionAppName         | ResourceGroupNameFunc   |
| scm-textanalytics-nodejs-infra.json  | storageAccountName      | StorageAccountName      | ResourceGroupNameFunc   |
| scm-textanalytics-nodejs-infra.json  | taname                  | TextAnalyticsName       | ResourceGroupNameFunc   |
| scm-textanalytics-nodejs-infra.json  | applicationInsightsName | ApplicationInsightsName | ResourceGroupNameFunc   |
| scm-textanalytics-nodejs-infra.json  | cosmosDbAccount         | CosmosDbAccount         | ResourceGroupNameFunc   |
| scm-textanalytics-nodejs-infra.json  | serviceBusNamespaceName | ServiceBusNamespaceName | ResourceGroupNameFunc   |
| scm-textanalytics-nodejs-infra.json  | commonResGroup          | ResourceGroupName       | ResourceGroupNameFunc   |

:::tip
📝 To build SCM Textanalytics we need to use Node.js version 10.x.
:::

#### CI Build YAML

```yaml
pr: none
trigger:
  branches:
    include:
      - master
  paths:
    include:
      - day4-azdevops/apps/nodejs/textanalytics/*
      - day4-azdevops/apps/infrastructure/templates/scm-textanalytics-nodejs-common.json
      - day4-azdevops/apps/infrastructure/templates/scm-textanalytics-nodejs-infra.json
steps:
  - task: NodeTool@0
    inputs:
      versionSpec: '10.x'
    displayName: 'Install Node.js'
  - task: Bash@3
    inputs:
      workingDirectory: '$(Build.SourcesDirectory)/day4-azdevops/apps/nodejs/textanalytics'
      targetType: 'inline'
      displayName: 'npm install'
      script: npm install
  - task: ArchiveFiles@2
    displayName: 'Archive build files'
    inputs:
      rootFolderOrFile: '$(Build.SourcesDirectory)/day4-azdevops/apps/nodejs/textanalytics'
      includeRootFolder: false
      archiveType: zip
      archiveFile: $(Build.ArtifactStagingDirectory)/Adc.Scm.Textanalytics.zip
      replaceExistingArchive: true
  - task: CopyFiles@2
    inputs:
      sourceFolder: day4/apps/infrastructure/templates
      contents: |
        scm-textanalytics-nodejs-common.json
        scm-textanalytics-nodejs-infra.json
      targetFolder: $(Build.ArtifactStagingDirectory)
  - task: PublishPipelineArtifact@1
    inputs:
      targetPath: $(Build.ArtifactStagingDirectory)
      artifactName: drop
```

#### ARM Template Override Parameters

- `scm-textanalytics-nodejs-common.json`

  ```shell
  -taname $(TextAnalyticsName) -tatier $(TextAnalyticsTier) -storageAccountName $(StorageAccountName)
  ```

- `scm-textanalytics-nodejs-infra.json`

  ```shell
  -functionAppName $(FunctionAppName) -storageAccountName $(StorageAccountName) -taname $(TextAnalyticsName) -applicationInsightsName $(ApplicationInsightsName) -cosmosDbAccount $(CosmosDbAccount) -serviceBusNamespaceName $(ServiceBusNamespaceName) -commonResGroup $(ResourceGroupName)
  ```

:::tip
📝
Make sure that your AppService deployment task is configured as follows:

![App Service Deployment Task](./images/textanalytics-deployment-task.png)

:::

## Test the Application

Now that you have deployed all services to Azure it's time to test it!

- Go to the Azure Portal and navigate to the Resource Group `ADC-DAY4-SCM-DEV`
- Open the StorageAccount _**{prefix}** day4scmfedev_ and go to _Static website_
- Copy the url of the **Primary endpoint**
- Open a new browser window and paste the url. If everything is configured correctly, the Azure Developer College's Sample Application should work
- Try to add some Contacts, add Avatars and create VisitReports
- If you want you can check the Testing stage, too

## Application Insights

Now that we have created some test data, go to the _Application Insights_ instance of your Development stage and open the _Application Map_.

:::tip
📝If nothing is displayed, wait some minutes, it takes ts time until all data is pushed to ApplicationInsights.
:::

With Application Insights, Azure Monitor offers a _distributed tracing_ solution that makes a developer’s live easier. Application Insights offers an application map view which aggregates many transactions to show a topological view of how the systems interact, and what the average performance and error rates are.

Take some time and look at the map to see what information an operator can get from it.

![ApplicationMap](./images/applicationinsights-appmap.png)

Now navigate to the _Performance_ view. Here you find all details about operations and dependencies of your services.
In the upper panel you can apply filters to investigate your telemetry:

![Performance Filter](./images/aiperf-filter.png)

Check out some details about the SCM API operations:

![Operations](./images/ai-operation-details.png)

Drill into a sample and see the "End-to-End transaction":

![Sample](./images/operation-drill.png)

## Congratulation

🥳 **Congratulation** - You've done it! 🥳

[◀ Previous challenge](./challenge-5.md) | [🔼 Day 4](../README.md) |
