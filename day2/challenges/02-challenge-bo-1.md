# 💎 Breakout 1: Deploy the Azure Dev College sample application to Azure 💎

⏲️ _Est. time to complete: 30 min._ ⏲️

## Here is what you will learn 🎯

Now it's time to get familiar with our sample application. In this challenge you will:

- clone the repository to your local machine
- setup your "local loop"
- deploy a first version to Azure

![architecture_bo1](./images/architecture_bo1.png 'architecture_bo1')

:::tip
📝 Please check, that all the [prerequisites](challenge-0.md) are set up in your machine.
:::

## Table Of Contents

1. [Setup Local Loop](#setup-local-loop)
2. [Run the Contacts Service locally](#run-the-contacts-service-locally)
3. [Deploy to Azure](#deploy-to-azure)
4. [Finished before Time?](#finished-before-time)
5. [Wrap-Up](#wrap-up)

## Setup Local Loop

Clone the repository to your local machine. Run this command from a blank folder.

```shell
$ git clone https://github.com/azuredevcollege/trainingdays.git

Cloning into 'azure-developer-college'...
remote: Enumerating objects: 236, done.
remote: Counting objects: 100% (236/236), done.
remote: Compressing objects: 100% (178/178), done.
remote: Total 2473 (delta 89), reused 177 (delta 51), pack-reused 2237
Receiving objects: 100% (2473/2473), 22.78 MiB | 16.39 MiB/s, done.
Resolving deltas: 100% (1392/1392), done.
```

Switch to the `azure-developer-college` folder where the repo has been cloned into and open VS Code from there. We will be using a VS Code Workspace file ([What are VS Code Workspaces?](https://code.visualstudio.com/docs/editor/workspaces#:~:text=1%20Configure%20settings%20that%20only%20apply%20to%20a,enable%20or%20disable%20extensions%20only%20for%20that%20workspace.)):

```shell
cd day2
code day2-breakout1.code-workspace
```

The structure of the workspace is as follows:

![Day2 Workspace Structure](./images/bo1_code.png 'bo1_code')

The projects that are relevant for this breakout challenge are:

- **Contacts API** - contains the backend logic for working with _contacts_ objects
- **Contacts Domain Objects** - contains the defintion for _contacts_ objects
- **Contacts Data EF Core** - contains the persistence logic for _contacts_ objects
- **Contacts Interfaces** - contains interface definitions for _contacts_ objects
- **Frontend** - contains the _Single Page Application_ (SPA) which is written in Vue.js

Open each folder and get familiar with the code in there.

:::tip
📝 If you have any questions, reach out to one of the proctors.
:::

## Run the Contacts Service locally

Now it's time to run the contacts API on your local machine. Therefore, a debug configuration has already been prepared for you. So, switch to the "Debug" view in Visual Studio Code and in the drop-down, choose **Day2 - Launch SCM Contacts API**. Click the **"Run"** button.

![vscode_debug_contacts](./images/vscode_debug_contacts.png 'vscode_debug_contacts')

If you set up your machine correctly, a browser window will open and show the Swagger UI for the _contacts_ API after a few seconds. Get familiar with all the available operations and also test a few of them via the UI.

![browser_swagger_contacts](./images/browser_swagger_contacts.png 'browser_swagger_contacts')

### Preparing the SPA for the first run

To run the Single Page Application on your local machine, we first need to tell the SPA where to call the contacts service.

:::tip
📝 The contacts API endpoint, as well as all other upcoming endpoints, can be dynamically configured per environment).
:::

Open the file `public/settings/settings.js` in the `Frontend` folder and make sure the property `endpoint` has the value `http://localhost:5050`.

```json{2}
var uisettings = {
    "endpoint": "http://localhost:5050/",
    "resourcesEndpoint": "",
    "aiKey": ""
}
```

This file will be loaded during the startup of our application and will configure the contacts module to use our local service for contacts management.

So, everything is in place now...let's start the application. Go back to the _Debug_ view, choose **Day2 - Launch Frontend**.

:::tip
📝 VS Code will automatically call `npm install` and afterwards `npm run serve` for you via the launch task. There **may** be a problem when running that debug configuration. In case `npm` cannot be started, please go to the command-line and run `npm install` and `npm run serve`!
:::

⚠ **IMPORTANT**: Make sure the contacts API still runs! ⚠

When you run the config, a local build will be kicked-off. You can open a browser and point it the `http://localhost:8080` to access the application. Get familiar with it, open the contacts list, create a few contacts, edit a contact and delete one.

If you want to, you can also test the mobile experience of the app by opening the Chrome/Edge Developer Tool (**F12**) and switching to a mobile user-agent.

![browser_bo1](./images/browser_bo1.png 'browser_bo1')

![browser_mobile_bo1](./images/browser_mobile_bo1.png 'browser_mobile_bo1')

## Deploy to Azure

We have now been able to run the application locally. Of course, we want to have it in Azure. In this first Break Out, we only deploy the _Contacts_ API to Azure and run the SPA on our local machine.

So, first of all, let's deploy the backend to Azure. You already know how to do it ([Challenge 1 - Azure Web Applications](./01-challenge-appservice.md) is your "cheat sheet"), so here is just an overview:

1. Basic Setup via Portal or Azure CLI

| Parameter        | Value                               |
| ---------------- | ----------------------------------- |
| _Resource group_ | new, name it e.g. `scm-breakout-rg` |
| _Location_       | West Europe                         |

2. Create an Azure Web App

| Parameter      | Value                    |
| -------------- | ------------------------ |
| _OS_           | Windows                  |
| _RuntimeStack_ | NET 6 (LTS)              |
| _Size_         | S1                       |
| _AppInsights_  | Not needed at the moment |

3. Deploy the _Contacts API_ to Azure (see the tips below)
4. After deployment, check whether the API is running by opening the Swagger UI

:::tip
You can right-click on the folder `Contacts API` and deploy it to the Azure App Service (via "Deploy to Web App..." in the context menu). VS Code will automatically build the project to a folder called `publish` and deploy its contents to Azure for you. The configuration for all these steps is located in the files `.vscode/settings.json` and `.vscode/tasks.json`.
:::

When everything works as expected in Azure, go back to the `settings.js` file of your SPA and adjust the **endpoint** property. Enter the value of your newly deployed API for it, e.g. `https://mynewcontactsapi.azurewebsites.net/`.

Open the browser and check, if your application still works as expected.

## Finished before Time?

Try adding slots to your app and deploy the service to the slot. Afterwards swap it.

## Wrap-Up

🎉 **_Congratulations_** 🎉

You have now set up your local development environment. You cloned the repository, installed the dependencies of the Single Page Application, ran both services locally and deployed the contacts API to Azure. You made use of:

- [Azure AppServices](https://docs.microsoft.com/azure/app-service/)
- [Vue.JS](https://vuejs.org/)

[◀ Previous challenge](./01-challenge-appservice.md) | [🔼 Day 2](../README.md) | [Next challenge ▶](./03-challenge-serverless.md)
