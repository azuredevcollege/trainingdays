# Break Out: Integrate the sample application into Azure AD

## Here is what you will learn

Deploy the sample application with Azure AD Integration.

In [challenge-3](./challenge-3.md) we already created the needed Azure AD applications to integrate the SCM Contacts API into Azure AD. We acquired an access_token from Azure AD and made a request to the API. Now it's time to integrate all APIs of the sample application into Azure AD.

Here is the list of the remaining services we have to integrate into Azure AD:

- SCM Resource API
- SCM Search API
- SCM Visitreports API
- SCM Textanalytics
- SCM Frontend

> If you started this day based on the checkpoint, please [**follow
> this link**](../apps/checkpoint/ChallengeAndBreakout.md#modified-steps-for-break-out-session) to see an adopted guide.

As in [challenge-3](./challenge-3.md) we always perform the following steps for each service:

1. Create and checkout a new branch
2. Edit the the existing build definition and change everything from `day4` to `day5`
3. Save the definition, commit the changes and push the branch to the remote repository
4. Run the build targeting the feature branch
5. Edit the Release defintion, add the needed variables and adjust the deployment tasks
6. Run the Release build
7. Merge the feature branch into the master branch

We don't need to create additional Azure AD applications for the remaining services. All APIs uses the same Azure AD application that we already created in [challenge-3](./challenge-3.md) for each stage (Development and Testing). The Frontend services uses the client application.

**Note:** Be carefull that you don't confuse the IDs of the stage `Development` and `Testing`.

## SCM Frontend

Feature branch: **features/scmfrontendaad**

Build definition yaml: **scm-frontend-ci.yaml**

Release definition: **SCM-Frontend-CD**

CD Build variables for stage **Development**:

| Name                | Value                                                                                                                 |
| ------------------- | --------------------------------------------------------------------------------------------------------------------- |
| AadTenantId         | the Id of your Azure Ad Tenant                                                                                        |
| AadApiClientIdUri   | http://scmapi-dev                                                                                                     |
| AadFrontendClientId | UI AppId, the value that you received from the output when you created the Azure AD application for stage Development |

CD Build variables for stage **Testing**:

| Name                | Value                                                                                                             |
| ------------------- | ----------------------------------------------------------------------------------------------------------------- |
| AadTenantId         | the Id of your Azure Ad Tenant                                                                                    |
| AadApiClientIdUri   | http://scmapi-test                                                                                                |
| AadFrontendClientId | UI AppId, the value that you received from the output when you created the Azure AD application for stage Testing |

**Note** As on Day4 we have to configure the settings for the SCM Frontend. Adjust the Azure CLI task which applies the settings to `dist/settings.js` as follows:

```
echo "var uisettings = { \"tenantId\": \"$(AadTenantId)\", \"audience\": \"$(AadApiClientIdUri)\", \"clientId\": \"$(AadFrontendClientId)\", \"enableStats\": true, \"endpoint\": \"$(ContactsEndpoint)\", \"resourcesEndpoint\": \"$(ResourcesEndpoint)\", \"searchEndpoint\": \"$(SearchEndpoint)\", \"reportsEndpoint\": \"$(ReportsEndpoint)\", \"aiKey\": \"`az resource show -g $(ResourceGroupName) -n $(ApplicationInsightsName) --resource-type "microsoft.insights/components" --query "properties.InstrumentationKey" -o tsv`\" };" > $(System.ArtifactsDirectory)/_SCM-Frontend-CI/drop/dist/settings/settings.js
```

> Please skip this step if you've started on the checkpoint, the correct
> variable replacement should already be in place.

Make sure that you copy the whole line!

## SCM Resource API

Feature branch: **features/scmresourcesaad**

Build definition yaml: **scm-resources-ci.yaml**

Release defintion: **SCM-Resources-CD**

CD Build variables for stage **Development**:

| Name           | Value                                                                                            | ARM Template parameter | Stage       |
| -------------- | ------------------------------------------------------------------------------------------------ | ---------------------- | ----------- |
| AadInstance    | https://login.microsoftonline.com                                                                | aadInstance            | Development |
| AadClientId    | API AppId, the value that you received from the output when you created the Azure AD application | aadClientId            | Development |
| AadTenantId    | The id of your Azure AD Tenant                                                                   | aadTenantId            | Development |
| AadDomain      | The domain name of your Azure AD e.g. azuredevcollege.onmicrosoft.com                            | aadDomain              | Development |
| AadClientIdUri | http://scmapi-dev                                                                                | aadClientIdUri         | Development |

CD Build variables for stage **Testing**

| Name           | Value                                                                                                              | ARM Template parameter | Stage   |
| -------------- | ------------------------------------------------------------------------------------------------------------------ | ---------------------- | ------- |
| AadInstance    | https://login.microsoftonline.com                                                                                  | aadInstance            | Testing |
| AadClientId    | API AppId, the value that you received from the output when you created the Azure AD application for stage Testing | aadClientId            | Testing |
| AadTenantId    | The id of your Azure AD Tenant                                                                                     | aadTenantId            | Testing |
| AadDomain      | The domain name of your Azure AD e.g. azuredevcollege.onmicrosoft.com                                              | aadDomain              | Testing |
| AadClientIdUri | http://scmapi-test                                                                                                 | aadClientIdUri         | Testing |

ARM Template override template parameters:

```
-webAppName $(ApiAppName) -sku $(AppServicePlanSKU) -use32bitworker $(Use32BitWorker) -alwaysOn $(AlwaysOn) -storageAccountName $(StorageAccountName) -functionAppName $(ResizerFunctionName) -applicationInsightsName $(ApplicationInsightsName) -serviceBusNamespaceName $(ServiceBusNamespaceName) -aadInstance $(AadInstance) -aadClientId $(AadClientId) -aadTenantId $(AadTenantId) -aadDomain $(AadDomain) -aadClientIdUri $(AadClientIdUri)
```

## SCM Search API

Feature branch: **features/scmsearchaad**

Build definition yaml: **scm-search-ci.yaml**

Release definition: **SCM-Search-CD**

CD Build variables for stage **Development**:

| Name           | Value                                                                                            | ARM Template parameter | Stage       |
| -------------- | ------------------------------------------------------------------------------------------------ | ---------------------- | ----------- |
| AadInstance    | https://login.microsoftonline.com                                                                | aadInstance            | Development |
| AadClientId    | API AppId, the value that you received from the output when you created the Azure AD application | aadClientId            | Development |
| AadTenantId    | The id of your Azure AD Tenant                                                                   | aadTenantId            | Development |
| AadDomain      | The domain name of your Azure AD e.g. azuredevcollege.onmicrosoft.com                            | aadDomain              | Development |
| AadClientIdUri | http://scmapi-dev                                                                                | aadClientIdUri         | Development |

CD Build variables for stage **Testing**

| Name           | Value                                                                                                              | ARM Template parameter | Stage   |
| -------------- | ------------------------------------------------------------------------------------------------------------------ | ---------------------- | ------- |
| AadInstance    | https://login.microsoftonline.com                                                                                  | aadInstance            | Testing |
| AadClientId    | API AppId, the value that you received from the output when you created the Azure AD application for stage Testing | aadClientId            | Testing |
| AadTenantId    | The id of your Azure AD Tenant                                                                                     | aadTenantId            | Testing |
| AadDomain      | The domain name of your Azure AD e.g. azuredevcollege.onmicrosoft.com                                              | aadDomain              | Testing |
| AadClientIdUri | http://scmapi-test                                                                                                 | aadClientIdUri         | Testing |

ARM Template overrides template parameters:

```shell
-webAppName $(ApiAppName) -appPlanSKU $(AppServicePlanSKU) -use32bitworker $(Use32BitWorker) -alwaysOn $(AlwaysOn) -storageAccountName $(StorageAccountName) -functionAppName $(IndexerFunctionName) -applicationInsightsName $(ApplicationInsightsName) -serviceBusNamespaceName $(ServiceBusNamespaceName) -azureSearchServiceName $(AzureSearchServiceName) -azureSearchSKU $(AzureSearchSKU) -azureSearchReplicaCount $(AzureSearchReplicaCount) -azureSearchPartitionCount $(AzureSearchPartitionCount) -aadInstance $(AadInstance) -aadClientId $(AadClientId) -aadTenantId $(AadTenantId) -aadDomain $(AadDomain) -aadClientIdUri $(AadClientIdUri)
```

## SCM VisitReports API

Feature branch: **features/scmvisitreportsaad**

Build definition yaml: **scm-visitreports-ci.yaml**

Release definition: **SCM-VisitReports-CD**

CD Build variables for stage **Development**:

**Note:** You only need to adjust the deployment task that uses the ARM template **scm-visitreport-nodejs-infra.json**

| Name           | Value                          | ARM Template parameter | Stage       |
| -------------- | ------------------------------ | ---------------------- | ----------- |
| AadTenantId    | The id of your Azure AD Tenant | aadTenantId            | Development |
| AadClientIdUri | http://scmapi-dev              | aadClientIdUri         | Development |

CD Build variables for stage **Testing**

| Name           | Value                          | ARM Template parameter | Stage   |
| -------------- | ------------------------------ | ---------------------- | ------- |
| AadTenantId    | The id of your Azure AD Tenant | aadTenantId            | Testing |
| AadClientIdUri | http://scmapi-test             | aadClientIdUri         | Testing |

ARM Template overrides template parameters for **scm-visitreport-nodejs-infra.json**

```shell
-sku $(AppServicePlanSKU) -skuCode $(AppServicePlanSKUCode) -webAppName $(ApiAppName) -applicationInsightsName $(ApplicationInsightsName) -cosmosDbAccount $(CosmosDbAccount) -serviceBusNamespaceName $(ServiceBusNamespaceName) -commonResGroup $(ResourceGroupName) -aadTenantId $(AadTenantId) -aadClientIdUri $(AadClientIdUri)
```

## SCM Textanalytics

Feature branch: **features/scmtextanalyticsaad**

Build definition yaml: **scm-textanalytics-ci.yaml**

Release definition: **SCM-TextAnalytics-CD**

**Note:** As the service SCM TextAnalytics does not offer an accessible API there is no need to adjust the Release build. We only need to adjust the build definition, create a new build and deploy it to Azure.

## Wrap up

You've done it. There is nothing more to add, just test the application and enjoy your success :-)
