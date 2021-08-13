# 💎 Breakout 2: Add Congitive Services 💎

⏲️ *Est. time to complete: 30 min.* ⏲️

## Here is what you will learn 🎯

Now that we have seen how Azure Congitive Services can easily enhance applications with out-of-the-box AI functionality, let's add one of those services from the text analytics space to our application.

In this challenge you will:

- use Azure Cognitive Services / Text Analytics to analyze the sentiment of visit report results

## Table Of Contents

- [💎 Breakout 2: Add Congitive Services 💎](#-breakout-2-add-congitive-services-)
  - [Here is what you will learn 🎯](#here-is-what-you-will-learn-)
  - [Table Of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Create a Cognitive Services Account](#create-a-cognitive-services-account)
  - [Create an Azure Function to Analyze Visit Report Results](#create-an-azure-function-to-analyze-visit-report-results)
    - [Add Service Bus Topic Subscription](#add-service-bus-topic-subscription)
    - [Create the Azure Function App](#create-the-azure-function-app)
    - [Deploy the Text Analytics Function](#deploy-the-text-analytics-function)
  - [Adjust the Frontend](#adjust-the-frontend)
  - [Wrap-Up](#wrap-up)

## Introduction

It's time to finish our sample application from a services perspective. We'll now add Azure Cognitive Services to enhance our application with Artificial Intelligence.

Whenever a visit report will be saved - **and the visit report _results_ field is filled with text** - we will be calling the Text Analysis services of Azure Cognitive Services to analyze the sentiment of the text. With that analysis, we can determine, if the visit was a "negative" or "positive" experience on a scala from "0" to "100". When the text has been analyzed, the Cosmos DB is updated to reflect the findings of our analysis.

The text analysis is triggered by a Service Bus topic which will receive a message, whenever a Visit Report will be added or updated.

This is a very common technique to add functionality to your application without touching the _core_ of it. You can extend without having to worry to break something.

Here is the resulting architecture:

![Architecture Day 3 - Breakout 2](../images/architecture_day3.png "Architecture Day 3 - Breakout 2")

## Create a Cognitive Services Account

To be able to use the text analysis services, we need to add an Azure Cognitive Services account.

Go to the Portal and create the new resource (search for _Cognitive Services_). Choose the **scm-breakout-rg** resource group, location "West Europe" and the lowest pricing tier available (probably **S0**).

![Azure Congitive Services Account](./images/portal_day4_bo_cgnsvc1.png "Azure Congitive Services Account")

## Create an Azure Function to Analyze Visit Report Results

As described in the introduction section, we will be using an Azure Function to call the Text Analyisis services - this time the function will be hosted on a Linux OS. It will be triggered by an Azure Service Bus Topic (**sbt-visitreports**) we created in the Break Out 1 session earlier this day.

### Add Service Bus Topic Subscription

First, we need to add the Service Bus Topic subscription. Please go to your Azure Service Bus and open the topic **sbt-visitreports**. Under **Subscriptions**, add a new one called **textanalytics**. Make sure sessions are **disabled** and **Max delivery count** is set to `10` - leave all other properties as proposed by the Azure Portal.

### Create the Azure Function App

Now, create an Azure Function App. Please keep in mind, that we need to add the function to a **new resource group**, because we can't mix Windows and Linux workloads at the time of writing.

So please open the "Create a Resource" wizard and start creating an Azure Function.

**Azure Function Properties**

Create the Azure Function App with the following parameters.

| Parameter        | Value / Hint                                                                                                                                                                                                                  |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Resource Group   | Create a **new** resource group, e.g. **scm-breakout-tuxfunc-rg** (Linux dynamic workers currently can't be mixed with Windows dynamic workers. Use this link to learn more <http://go.microsoft.com/fwlink/?LinkId=825764>.) |
| Publish          | _Code_                                                                                                                                                                                                                        |
| Runtime Stack    | _Node.js_                                                                                                                                                                                                                     |
| Version          | _14 LTS_                                                                                                                                                                                                                      |
| Region           | _West Europe_                                                                                                                                                                                                                 |
| Storage Account  | use the Storage Account you created in the breakout resource group (or you can also create a new one)                                                                                                                         |
| Operating System | _Linux_                                                                                                                                                                                                                       |
| Plan Type        | _Consumption_                                                                                                                                                                                                                 |

Create it and when the Function App has been deployed, go to the **Configuration** section and add the following App configuration/settings.

| Parameter                  | Value / Hint                                                                                                                                                                                                                                                                    |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ServiceBusConnectionString | Primary Connection String of the Service Bus **Visit Reports** Topic (**sbt-visitreports** / **listen** Shared Access Key) <br><br><span style="color:red">**Important**</span>: Please remove the _EntityPath_ variable (incl. the value) at the end of the connection string! |
| COSMOSDB                   | the endpoint to the Cosmos DB, e.g. <https://adcd3cosmos-dev.documents.azure.com:443/>                                                                                                                                                                                          |
| COSMOSKEY                  | Primary Key of your Cosmos DB                                                                                                                                                                                                                                                   |
| TA_SUBSCRIPTION_KEY        | the Azure Cognitive Services **subscription key**. Obtain it from the _Keys and Endpoint_ view under _Resource Management_ of your Cognitive Services account                                                                                                                   |
| TA_SUBSCRIPTIONENDPOINT    | the Azure Cognitive Services **endpoint URL**. Obtain it from the _Keys and Endpoint_view under_Resource Management_ of your Cognitive Services account                                                                                                                         |

Save the settings. We can now start deploying the code that will call the Azure Cognitive services.

### Deploy the Text Analytics Function

This is the last part that we add to our application. The code for the Azure Function that sends visit report results to Azure Congitive Services / Sentiment Analysis has been prepared for. Please open the VS Code Worskpace `day3/day3-breakout2.code-workspace`.

The folder structure is now as follows:

![VS Code Day 3 - Breakout 2](./images/bo2_code.png "VS Code Day 3 - Breakout 2")

You will see one additional project added to the workspace compared to `Breakout 1`:

- **Text Analytics Function** - contains the logic to send visit reports to Azure Congitive Services / Text Analytics to analyze the sentiment of visit report results

**You can now deploy the project** to the previously created Azure Function via "right-click deployment" directly from VS Code - as done many times by now.

## Adjust the Frontend

There is one last step to do, until we can see the new functionality in action. We need to adjust the frontend and enable the feature flag "enableStats". Please set this flag to **_true_**. You can either do this on you local machine and redeploy the frontend (again, see [Breakout Session 1](./challenge-bo-1.md#deploy-new-frontend)) or you simply open the **Azure Storage Explorer in the Portal** and edit the file directly.

The settings file should look similar to that one now:

```json
var uisettings = {
    "endpoint": "https://adcday3scmapi-dev.azurewebsites.net/",
    "resourcesEndpoint": "https://adcday3scmresourcesapi-dev.azurewebsites.net/",
    "searchEndpoint": "https://adcday3scmrsearchapi-dev.azurewebsites.net/",
    "reportsEndpoint": "https://adcday3scmvr-dev.azurewebsites.net",
    "enableStats": true,
    "aiKey": ""
}
```

Now open a browser and reload the frontend. You will see, that a new menu item is available.

![Sentiment Statistics](./images/browser_bo2_stats.png "Sentiment Statistics")

Also, the contacts detail view will show results of visit reports, if they are available for the current contact.

![Contact Detail - Sentiment Analysis](./images/browser_bo2_stats_contact.png "Contact Detail - Sentiment Analysis")

:::tip
📝 To kick-off the sentiment analysis process, create a `Visit Report`, open the detail view for it and enter a `Visit Result` text. Then wait a few seconds and open the `Statistics` view.
:::

## Wrap-Up

Congratulations! It was a hard and tough way to get to where you are now standing! You have created a basic, microservice oriented application with multiple backend services (contacts, resources, visit reports, search backend), that work independently, have their own storage, communicate via a Service Bus, can be granularly scaled etc. Ready to run globally!

From a services perspective, we have a full working, modern cloud application! Hold on for a while to reflect what we have done so far - and celebrate!

Tomorrow, we will show you how to deploy the application including the Azure infrastructure within minutes!

In this Breakout Challenge, you made use of:

- [Azure Cognitive Services / Text Analytics](https://docs.microsoft.com/azure/cognitive-services/text-analytics/)
- [Azure Functions on Linux](https://docs.microsoft.com/azure/azure-functions/create-function-app-linux-app-service-plan)

[◀ Previous challenge](./05-challenge-cognitive-services.md) | [🔼 Day 3](../README.md)
