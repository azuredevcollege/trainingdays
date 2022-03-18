# Challenge 4: Work with Azure Pipelines

![Azure Pipelines](../images/pipelines.svg)

## Here is what you will learn 🎯

- Create a CI build to create SCM Contacts API's deployment artifacts
- Create a _Pull Request_ validation build, that is triggered to validate a _Pull Request_
- Create a CD Build to deploy SCM Contacts API to the stages _Development_ and _Testing_

## Table of Contents

1. [Create the CI Build](#create-the-ci-build)
2. [Create the Pull Request Validation Build](#create-the-pull-request-validation-build)
3. [Create the CD Build](#create-the-cd-build)
4. [Create a Pull Request](#create-a-pull-request)
5. [Trigger the PR-Build to validate a Pull Request](#trigger-the-pr-build-to-validate-a-pull-request)
6. [See the Build Flow in Action](#see-the-build-flow-in-action)
7. [Wrap-Up](#wrap-up)

## Create the CI Build

Go to Azure Boards and set the User Story S4 and S5 to _active_. We create a new build definition with the steps as follows:

- Build the SCM Contacts API
- Copy the ARM Template to the artifact location
- Publish the artifacts

1. Create a feature branch _"features/scmcontactscicd"_ and check it out
2. Add a file named `scm-contacts-ci.yaml` in the directory `day4-azdevops/apps/pipelines`
3. Add the following yaml snippet that defines the build Trigger:

```yaml
pr: none
trigger:
  branches:
    include:
      - master
  paths:
    include:
      - day4-azdevops/apps/infrastructure/templates/scm-api-dotnetcore.json
      - day4-azdevops/apps/dotnetcore/Scm/*
```

Here we specified when the build must be triggered. The build is triggered only if changes were made to the master branch and when the changes were made to either `_day4-azdevops/apps/infrastructure/templates/scm-api-dotnetcore.json_` or to any files under directory `\*day4-azdevops/apps/dotnetcore/Scm/\*\*`

4. Add the following yaml snippet to define the needed build steps:

```yaml
jobs:
  - job: Build
    displayName: Build Scm Contacts
    pool:
      vmImage: ubuntu-latest
    steps:
      - task: DotNetCoreCLI@2
        displayName: Restore
        inputs:
          command: restore
          projects: 'day4-azdevops/apps/dotnetcore/Scm/**/*.csproj'
      - task: DotNetCoreCLI@2
        displayName: Build
        inputs:
          projects: 'day4-azdevops/apps/dotnetcore/Scm/**/*.csproj'
          arguments: --configuration Release
      - task: DotNetCoreCLI@2
        displayName: Publish
        inputs:
          command: publish
          publishWebProjects: false
          projects: day4-azdevops/apps/dotnetcore/Scm/Adc.Scm.Api/Adc.Scm.Api.csproj
          arguments: --configuration Release --output $(build.artifactstagingdirectory)
          zipAfterPublish: True
      - task: CopyFiles@2
        inputs:
          sourceFolder: day4-azdevops/apps/infrastructure/templates
          contents: |
            scm-api-dotnetcore.json
          targetFolder: $(Build.ArtifactStagingDirectory)
      - task: PublishPipelineArtifact@1
        inputs:
          targetPath: $(Build.ArtifactStagingDirectory)
          artifactName: drop
```

5. Commit your changes and push the branch to your remote repository.
6. Navigate to your Azure DevOps project
7. In your project navigate to the Pipelines page. Then choose the action to create a new pipeline
8. Walk through the steps of the wizard by first selecting Azure Repos Git as the location of your source code
9. Select your college repository
10. Select _"Existing Azure Pipelines YAML file"_
11. Select your feature branch and specify the path: _"/day4-azdevops/apps/pipelines/scm-contacts-ci.yaml"_
12. Run your CI Build by clicking the action _"Run"_
13. Rename your CI Build to _"SCM-Contacts-CI"_
14. Navigate to the Pipelines page and open the last run of the build _"SCM-Contacts-CI"_. You see that the artifact is linked to your build.

## Create the Pull Request Validation Build

In [Challenge 2](./challenge-2.md) we configured the master branch's policies to require a _Pull Request_ before changes are merged into the master.
With Azure Pipelines you can define a build that is executed whenever a Pull Request is created in order to validate a merge into the master branch.

1. Add a file named `scm-contacts-pr.yaml` in the directory `day4-azdevops/apps/pipelines`
2. Add the following yaml snippet:

```yaml
trigger: none
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
          projects: 'day4-azdevops/apps/dotnetcore/Scm/**/*.csproj'
      - task: DotNetCoreCLI@2
        displayName: Build
        inputs:
          projects: 'day4-azdevops/apps/dotnetcore/Scm/**/*.csproj'
          arguments: --configuration Release
      - task: DotNetCoreCLI@2
        displayName: Publish
        inputs:
          command: publish
          publishWebProjects: false
          projects: day4-azdevops/apps/dotnetcore/Scm/Adc.Scm.Api/Adc.Scm.Api.csproj
          arguments: --configuration Release --output $(build.artifactstagingdirectory)
          zipAfterPublish: True
```

3. Commit your changes and push the branch to your remote repository.
4. Navigate to your Azure DevOps project
5. In your project navigate to the Pipelines page. Then choose the action to create a new pipeline
6. Walk through the steps of the wizard by first selecting Azure Repos Git as the location of your source code
7. Select your repository
8. Select _"Existing Azure Pipelines YAML file"_
9. Select your feature branch and specify the path: _"/day4-azdevops/apps/pipelines/scm-contacts-pr.yaml"_
10. Run your PR Build by clicking the action _"Run"_
11. Rename your PR Build to _"SCM-Contacts-PR"_

## Create the CD Build

Now we have created the deployment artifacts with the build _SCM-Contacts-CI_. It is time to create a Release build to deploy the SCM Contacts API to Azure. As in [Challenge 3](./challenge-3.md) we deploy the artifacts to the stages _Development_ and _Testing_ and we create a manual _Pre-deployment condition_ to approve the deployment to the _Testing_ stage.

1. Create a new release pipeline and name it _SCM-Contacts-CD_
2. Add the SCM-Contacts-CI build's artifacts
3. Create a _Development_ stage
4. Add the the following variables and replace **'prefix'** with your own value:

   | Variable                | Value                                                       | Scope       |
   | ----------------------- | ----------------------------------------------------------- | ----------- |
   | ResourceGroupName       | ADC-DAY4-SCM-DEV                                            | Development |
   | Location                | westeurope                                                  | Development |
   | ApiAppName              | **'prefix'**-day4scmapi-dev                                 | Development |
   | AppServicePlanSKU       | B1                                                          | Development |
   | Use32BitWorker          | false                                                       | Development |
   | AlwaysOn                | true                                                        | Development |
   | ApplicationInsightsName | your ApplicationInsights instance name of stage Development | Development |
   | SqlServerName           | **'prefix'**-day4sqlsrv-dev                                 | Development |
   | SqlDatabaseName         | scmcontactsdb                                               | Development |
   | SqlAdminUserName        | _your Sql Admin's username_                                 | Development |
   | SqlAdminPassword        | _your password_                                             | Development |
   | ServiceBusNamespaceName | your ServiceBus namespace name of stage Development         | Development |

5. Go to the Tasks section of the _"Development"_ stage and use the latest Ubuntu version to run the agent on
6. Add the task _"ARM template deployment"_
7. Select your Azure Subscription
8. Set the name of the ResourceGroup, use the variable \$(ResourceGroupName)
9. Set the Location, use the variable \$(Location)
10. Select the template from your drop location
11. Override the template parameters as follow:

    ```shell
    -sku $(AppServicePlanSKU) -webAppName $(ApiAppName) -use32bitworker $(Use32BitWorker) -alwaysOn $(AlwaysOn) -applicationInsightsName $(ApplicationInsightsName) -sqlServerName $(SqlServerName) -sqlUserName $(SqlAdminUserName) -sqlPassword "$(SqlAdminPassword)" -sqlDatabaseName $(SqlDatabaseName) -serviceBusNamespaceName $(ServiceBusNamespaceName)
    ```

    Make sure that you copy the whole line.
12. Add _Azure App Service deploy_ task
13. Select your Azure Subscription
14. Choose _API App_ as AppService type
15. Use the variable _\$(ApiAppName)_ to set the App Service name
16. Add your dotnet core deployment zip file from your artifact location
17. Save the release definition and create a release to check if everything works

### Create the _Testing_ stage

1. Edit the Release definition and go to the task view
2. Clone the _Development_ stage and rename the cloned stage to _Testing_
3. Open the Release definition's variable view and add new variables as follow:

   | Variable                | Value                                                   | Scope   |
   | ----------------------- | ------------------------------------------------------- | ------- |
   | ResourceGroupName       | ADC-DAY4-SCM-TEST                                       | Testing |
   | Location                | westeurope                                              | Testing |
   | ApiAppName              | **'prefix'**-day4scmapi-test                            | Testing |
   | AppServicePlanSKU       | B1                                                      | Testing |
   | Use32BitWorker          | false                                                   | Testing |
   | AlwaysOn                | true                                                    | Testing |
   | ApplicationInsightsName | your ApplicationInsights instance name of stage Testing | Testing |
   | SqlServerName           | **'prefix'**-day4sqlsrv-test                            | Testing |
   | SqlDatabaseName         | scmcontactsdb                                           | Testing |
   | SqlAdminUserName        | _your Sql Admin's username_                             | Testing |
   | SqlAdminPassword        | _your password_                                         | Testing |
   | ServiceBusNamespaceName | your ServiceBus namespace name of stage Testing         | Testing |

4. Save the definition and create a release

## Create a Pull Request

Create a Pull Request and merge all changes into the master branch. Don't forget to link the User Stories S4 and S5.

## Trigger the PR-Build to validate a Pull Request

Now we have to enable the PR-Build to be triggered whenever a Pull Request is created and when files are changed that belongs to the SCM Contacts API.

1. Open the branch policies of the master branch
2. Add a build validation and select your SCM-Contacts-PR build
3. Set the path filter as follow:

   ```shell
   /day4-azdevops/apps/infrastructure/templates/scm-api-dotnetcore.json;/day4-azdevops/apps/dotnetcore/Scm/*
   ```

   With this filter the PR build is only triggered when files were changed that belongs to the SCM Contacts API
4. Save your changes

## See the Build Flow in Action

Now it's time to see the whole build flow in action.

1. Checkout the master branch and pull the latest changes
2. Create and checkout a new feature branch _features/scmcontactsflow_
3. Open the file [day4-azdevops/apps/dotnetcore/Scm/Adc.Scm.Api/Startup.cs](../apps/dotnetcore/Scm/Adc.Scm.Api/Startup.cs) and change the name of the API in the Swagger configurations:

   ```csharp
   // here
   c.SwaggerDoc("v1", new OpenApiInfo { Title = "ADC Contacts API", Version = "v1" });
   // and here
   c.SwaggerEndpoint("/swagger/v1/swagger.json", "ADC Contacts API v1");
   ```

4. Commit your changes and push the feature branch to your remote repository
5. Create a _Pull Request_ to merge the changes into the master branch. Don't forget to link the User Story S5.
   You will see that the PR-Build is part of the required policies of your Pull Request.
   ![PullRequest](./Images/../images/pr-build-validation.png)
6. Complete your Pull Request
7. Navigate to the Pipelines view and you will notice that the SCM-Contacts-CI build is triggered
   ![SCM-Contact-CI](./images/scm-contacts-ci.png)
   Wait until the build is finished and the deployment artifacts are available.
8. Navigate to the Release view and you will see that the CD Pipeline is triggered and starts to deploy the artifacts to the Development stage.
9. Go to Azure Boards and set the User Stories S4 and S5 to completed.

## Wrap-Up

🥳 **Congratulation** - You have completed the User Stories S4 and S5. 🥳

Now you have seen how you can create a _Pull Request validation build_ that protects your master branch from build breaks. After changes are merged into the master branch, the CI build is triggered and it creates the deployment artifacts. The deployment artifacts are then deployed to your stages. After this challenge we have the following architecture deployed to Azure:

![SCM Contacts API](./images/scm-contacts-api-arch.png)

Now navigate to the Azure portal, open the SCM Contacts API's API App in the ResourceGroup `ADC-DAY4-SCM-TEST` and browse to the Swagger UI.
If you want you can test the API.

[◀ Previous challenge](./challenge-3.md) | [🔼 Day 4](../README.md) | [Next challenge ▶](./challenge-5.md)
