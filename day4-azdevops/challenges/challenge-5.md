# Challenge 5: Build and deploy the SCM Frontend

![Azure Pipelines](../images/pipelines.svg)

## Here is what you will learn 🎯

- Create a CI build to create SCM Frontend's deployment artifacts
- Create a _Pull Request_ validation build, that is triggered to validate a _Pull Request_
- Create a CD Build to deploy SCM Frontend to the stages _Development_ and _Testing_

## Table of Contents

1. [Create the CI Build](#create-the-ci-build)
2. [Create the Pull Request Validation Build](#create-the-pull-request-validation-build)
3. [Create the CD Build](#create-the-cd-build)
4. [Create a Pull Request](#create-a-pull-request)
5. [Trigger the PR-Build to validate a Pull Request](#trigger-the-pr-build-to-validate-a-pull-request)
6. [See the Build Flow in Action](#see-the-build-flow-in-action)
7. [Wrap-Up](#wrap-up)

## Create the CI Build

Go to Azure Boards and set the User Story S14 and S15 to active. We create a new build definition with the steps as follows:

- Build the SCM Frontend
- Copy the ARM Template to the artifact location
- Publish the artifacts

1. Create a feature branch _"features/scmfrontendcicd"_ and check it out
2. Add a file named `scm-frontend-ci.yaml` in the directory `day4-azdevops/apps/pipelines`
3. Add the following yaml snippet that defines the build trigger:

```yaml
pr: none
trigger:
  branches:
    include:
      - master
  paths:
    include:
      - day4-azdevops/apps/frontend/*
      - day4-azdevops/apps/infrastructure/templates/scm-fe.json
```

Here we specified when the build must be triggered. The build is triggered only if changes were made to the master branch and when the changes were made to either `_day4-azdevops/apps/infrastructure/templates/scm-fe.json_` or to any files in the directory `_day4-azdevops/apps/frontend/\*_`

4. Add the following yaml snippet to define the needed build steps:

```yaml
steps:
  - task: Npm@1
    inputs:
      command: 'install'
      workingDir: 'day4-azdevops/apps/frontend/scmfe'
  - task: Npm@1
    inputs:
      command: 'custom'
      workingDir: 'day4-azdevops/apps/frontend/scmfe'
      customCommand: 'run build'
  - task: CopyFiles@2
    inputs:
      SourceFolder: 'day4-azdevops/apps/frontend/scmfe/dist'
      Contents: '**'
      TargetFolder: '$(Build.ArtifactStagingDirectory)/dist'
  - task: CopyFiles@2
    inputs:
      sourceFolder: day4-azdevops/apps/infrastructure/templates
      contents: |
        scm-fe.json
      targetFolder: $(Build.ArtifactStagingDirectory)/templates
  - task: PublishPipelineArtifact@1
    inputs:
      targetPath: $(Build.ArtifactStagingDirectory)
      artifactName: drop
```

5. Commit your changes and push the branch to your remote repository
6. Navigate to your Azure DevOps project
7. In your project navigate to the Pipelines page. Then choose the action to create a new Pipeline
8. Walk through the steps of the wizard by first selecting Azure Repos Git as the location of your source code
9. Select your college repository
10. Select _"Existing Azure Pipelines YAML file"_
11. Select your feature branch and specify the path: _"/day4/apps/pipelines/scm-frontend-ci.yaml"_
12. Run your CI Build by clicking the action _"Run"_
13. Rename your CI Build to _"SCM-Frontend-CI"_
14. Navigate to the Pipelines page and open the last run of the build _"SCM-Frontend-CI"_. You see that the artifact is linked to your build

## Create the Pull Request Validation Build

In [Challenge 2](./challenge-2.md) we configured the master branch's policies to require a _Pull Request_ before changes are merged into the master.
With Azure Pipelines you can define a build that is executed whenever a Pull Request is created in order to validate a merge into the master branch.

1. Add a file named `scm-frontend-pr.yaml` in the directory `day4/apps/pipelines`
2. Add the following yaml snippet:

```yaml
trigger: none
steps:
  - task: Npm@1
    inputs:
      command: 'install'
      workingDir: 'day4-azdevops/apps/frontend/scmfe'
  - task: Npm@1
    inputs:
      command: 'custom'
      workingDir: 'day4-azdevops/apps/frontend/scmfe'
      customCommand: 'run build'
```

3. Commit your changes and push the branch to your remote repository
4. Navigate to your Azure DevOps project
5. In your project navigate to the Pipelines page. Then choose the action to create a new pipeline
6. Walk through the steps of the wizard by first selecting Azure Repos Git as the location of your source code
7. Select your college repository
8. Select _"Existing Azure Pipelines YAML file"_
9. Select your feature branch and specify the path: _"/day4-azdevops/apps/pipelines/scm-frontend-pr.yaml"_
10. Run your PR Build by clicking the action _"Run"_
11. Rename your PR Build to _"SCM-Frontend-PR"_

## Create the CD Build

Now we have created the deployment artifacts with the build _SCM-Frontend-CI_. It is time to create a Release pipeline to deploy the SCM Frontend to Azure. As in [Challenge 3](./challenge-3.md) we deploy the artifacts to the stages _Development_ and _Testing_ and we create a manual _Pre-deployment condition_ to approve the deployment to the _Testing_ stage.

1. Create a new release build and name it _SCM-Frontend-CD_
2. Add the SCM-Frontend-CI build's artifacts
3. Create a _Development_ stage
4. Add the the following variables and replace **'prefix'** with your own value:
   | Variable               | Value                                                       | Scope       |
   |------------------------|-------------------------------------------------------------|-------------|
   |ResourceGroupName       | ADC-DAY4-SCM-DEV                                            | Development |
   |Location                | westeurope                                                  | Development |
   |StorageAccountName      | *{prefix}* day4scmfedev                                     | Development |
   |ApplicationInsightsName | your ApplicationInsights instance name of stage Development | Development |
   |ContactsEndpoint        | https endpoint of the SCM Contacts API in Development stage | Development |
   |ResourcesEndpoint       | _leave blank, will be needed later_                         | Development |
   |SearchEndpoint          | _leave blank, will be needed later_                         | Development |
   |ReportsEndpoint         | _leave blank, will be needed later_                         | Development |

5. Go to the Tasks section of the _"Development"_ stage and use the latest Ubuntu version to run the agent on
6. Add the task _"ARM template deployment"_
7. Select your Azure Subscription
8. Set the name of the ResourceGroup, use the variable \$(ResourceGroupName)
9. Set the Location, use the variable \$(Location)
10. Select the template from your drop location
11. Override the template parameters as follow:

    ```shell
    -storageAccountName $(StorageAccountName)
    ```

12. Add three additional Azure CLI Tasks. To deploy the SCM Frontend Single Page Application to a staging environment we need to set the endpoints of the APIs and the InstrumentationKey of ApplicationInsights. As we deploy the single application to a storage account we need to enable the static website hosting for the storage account. Use the following Azure CLI tasks before the application is deployed to the storage account and after the Resource Group deployment task:
    1. Azure CLI task "Enable static website hosting" inline script:

       ```shell
       az storage blob service-properties update --account-name $(StorageAccountName) --static-website  --index-document index.html --404-document index.html
       ```

    2. Azure CLI task "Configure SPA settings" inline script:

       ```shell
       echo "var uisettings = { \"enableStats\": true, \"endpoint\": \"$(ContactsEndpoint)\", \"resourcesEndpoint\": \"$(ResourcesEndpoint)\", \"searchEndpoint\": \"$(SearchEndpoint)\", \"reportsEndpoint\": \"$(ReportsEndpoint)\", \"aiKey\": \"`az resource show -g $(ResourceGroupName) -n $(ApplicationInsightsName) --resource-type "microsoft.insights/components" --query "properties.InstrumentationKey" -o tsv`\" };" > $(System.ArtifactsDirectory)/_SCM-Frontend-CI/drop/dist/settings/settings.js
       ```

    3. Azure CLI task "Copy SPA to StorageAccount" inline script:

       ```shell
       az storage blob upload-batch -d '$web' --account-name $(StorageAccountName) -s $(System.ArtifactsDirectory)/_SCM-Frontend-CI/drop/dist
       ```

13. Save the release definition and create a release to check if everything works

### Create the _Testing_ stage

1. Edit the Release definition and go to the task view
2. Clone the _Development_ stage and rename the cloned stage to _Testing_
3. Open the Release definition's variable view and add new variables as follow:

   | Variable                | Value                                                   | Scope   |
   | ----------------------- | ------------------------------------------------------- | ------- |
   | ResourceGroupName       | ADC-DAY4-SCM-TEST                                       | Testing |
   | Location                | westeurope                                              | Testing |
   | StorageAccountName      | *{prefix}* day4scmfetest                                | Testing |
   | ApplicationInsightsName | your ApplicationInsights instance name of stage Testing | Testing |
   | ContactsEndpoint        | https endpoint of the SCM Contacts API in Testing stage | Testing |
   | ResourcesEndpoint       | _leave blank, will be needed later_                     | Testing |
   | SearchEndpoint          | _leave blank, will be needed later_                     | Testing |
   | ReportsEndpoint         | _leave blank, will be needed later_                     | Testing |

4. Save the definition and create a release

## Create a Pull Request

Create a Pull Request and merge all changes into the master branch. Don't forget to link the User Stories S14 and S15.

## Trigger the PR-Build to validate a Pull Request

Now we have to enable the PR-Build to be triggered whenever a Pull Request is created and when files are changed that belongs to the SCM Frontend.

1. Open the branch policies of the master branch
2. Add a build validation and select your SCM-Frontend-PR build
3. Set the path filter as follow:

   ```shell
   /day4-azdevops/apps/infrastructure/templates/scm-fe.json;/day4-azdevops/apps/frontend/*
   ```

   With this filter the PR build is only triggered when files were changed that belongs to the SCM Frontend
4. Save your changes

## See the Build Flow in Action

Now it's time to see the whole build flow in action.

1. Checkout the master branch and pull the latest changes
2. Create and checkout a new feature branch _features/scmfrontendflow_
3. Open the file [day4/apps/frontend/scmfe/src/components/home/Home.vue](../apps/frontend/scmfe/src/components/home/Home.vue) and change the name the _Welcome_ text in line 13:

   ```HTML
   <h1 class="display-2 font-weight-bold mb-3">Welcome to My SCM Contacts App</h1>
   ```

4. Commit your changes and push the feature branch to your remote repository
5. Create a _Pull Request_ to merge the changes into the master branch. Don't forget to link the User Story S15.
   You will see that the PR-Build is part of the required policies of your Pull Request
   ![PullRequest](./Images/../images/pr-build-validation.png)
6. Complete your Pull Request
7. Navigate to the Pipelines view and you will notice that the SCM-Contacts-CI build is triggered
   ![SCM-Frontend-CI](./images/scm-frontend-ci.png)
   Wait until the build is finished and the deployment artifacts are available
8. Navigate to the Release view and you will see that the CD Pipeline is triggered and starts to deploy the artifacts to the Development stage
9. Go to Azure Boards and set the stories S14 and S15 to completed

## Wrap-Up

🥳 **Congratulation** - You have completed the User Stories S14 and S15 🥳

Now you have seen how you can create a Pull Request validation build that protects your master branch from build breaks. After changes are merged into the master branch, the CI build is triggered and it creates the deployment artifacts. The deployment artifacts are then deployed to your stages. After this challenge we have deployed the SCM Frontend to Azure. The SCM Contact API and SCM Frontend is running on Azure.

Now that you have deployed the Frontend to Azure it's time to test it! Go to the Azure Portal and navigate to the ResourceGroup `ADC-DAY4-SCM-DEV`. Open the StorageAccount `{prefix} day4scmfedev` and go to Static website. Copy the url of the primary endpoint, open a new browser window and paste the url.

If everything is configured correctly you can add some contacts.

:::tip
📝 At the moment we have only deployed the SCM Contacts API and the SCM Frontend. It is not possible to set an image for a contact or to create visit reports.
:::

[◀ Previous challenge](./challenge-4.md) | [🔼 Day 4](../README.md) | [Next challenge ▶](./challenge-bo-1.md)
