# Break Out #1: Deploy the Azure Dev College sample application to Azure #

Now it's time to get familiar with our sample application. You will now clone the repository to your local machine, setup your "local loop" and deploy a frist version to Azure.

![architecture_bo1](./img/architecture_bo1.png "architecture_bo1")

## Setup Local Loop ##

Clone the repository to your local machine. Run this command from a blank folder.

```shell
$ git clone https://github.com/CSA-OCP-GER/azure-developer-college.git

Cloning into 'azure-developer-college'...
remote: Enumerating objects: 236, done.
remote: Counting objects: 100% (236/236), done.
remote: Compressing objects: 100% (178/178), done.
remote: Total 2473 (delta 89), reused 177 (delta 51), pack-reused 2237
Receiving objects: 100% (2473/2473), 22.78 MiB | 16.39 MiB/s, done.
Resolving deltas: 100% (1392/1392), done.
```

> Please check, that all the [Prerequisites](challenge-0.md) are present on your machine.

Switch to the *azure-developer-college* folder and open VS Code:

```shell
$ code .
```

Open folder Day2/apps. In that folder, we will be concentrating on *dotnetcore/Scm* and *frontend/scmfe*.

![bo1_code](./img/bo1_code.png "bo1_code")

The first one contains the backend logic for working with *contacts* objects, the latter one contains the Single page Application (SPA) which is written in VueJS.

Open each folder and get familiar with the code in there.

> If you have any questions, reach out to one of the proctors.

## Run the *Contacts* service locally ##

Now it's time to run the contacts API on your local machine. Therefore, a debug configuration has already been prepared for you. So, switch to the "Debug" view in Visual Studio Code and in the drop-down, choose **Day2 - Launch SCM Contacts API**. Click the "Run" button.

![vscode_debug_contacts](./img/vscode_debug_contacts.png "vscode_debug_contacts")

If you correctly set up your machine, after a few seconds a browser window will open and show the Swagger UI for the *contacts* API.

Get familiar with all the available operations and also test a few of them via the UI.

![browser_swagger_contacts](./img/browser_swagger_contacts.png "browser_swagger_contacts")

### Preparing the SPA for the first run ###

To run the Single Page Application on your local machine, we first need to install all the neccessary Node packages via the Node Package Manager (NPM).

On the command line, switch to the folder *apps/frontend/scmfe* and run the following command:

```shell
$ npm install

[...]
[...]
[...]
added 1281 packages from 895 contributors and audited 26623 packages in 24.125s
[...]
[...]
```

Back in Visual Studio Code, we need to tell the SPA where to call the contacts service (the contacts API endpoint, as well as all other upcoming endpoint, can be dynamically configured per environment).

Open the file *apps/frontend/scmfe/public/settings/settings.js* and make sure the property *endpoint* has the value **http://localhost:5050**.

```json
var uisettings = {
    "endpoint": "http://localhost:5050/",
    "resourcesEndpoint": "",
    "aiKey": ""
}
```

This file will be loaded during the startup of our application and will configure the contacts module to use our local service for contacts management.

So, everything is in place now...let's start the application. Go back to the *Debug* view, choose **Day2 - Launch Frontend**.

**IMPORTANT**: Make sure the contacts API still runs!

When you run the config, a local build will be kicked-off and after finishing, the Chrome Debugger will be launched.

Again, get familiar with the application, open the contacts list, create a few contacts, edit a contact and delete one.

If you want to, you can also test the mobile experience of the app by opening the Chrome Developer Tool and switching to a mobile user-agent. 

![browser_bo1](./img/browser_bo1.png "browser_bo1")

![browser_mobile_bo1](./img/browser_mobile_bo1.png "browser_mobile_bo1")

## Deploy to Azure ##

We have now been able to run the application locally. Of course, we want to have it in Azure. In this first Break Out, we only deploy the *Contacts* API to Azure and run the SPA on our local machine.

So, first of all, let's deploy the backend to Azure. You already know how to do it ([Challenge 1 - Azure Web Applications](./challenge-1.md) is your "cheat sheet"), so here is just an overview:

1. create a new resource group, name it e.g. **scm-breakout-rg**, location *West Europe*
1. create an Azure Web App (OS: **Windows**, RuntimeStack: **.NET Core 3.0**, Size: **B1**, AppInsights is not needed at the moment). You can choose to use the Portal or the Azure CLI.
1. deploy the Contacts API to Azure
1. after deployment, check whether the API is running (open the Swagger UI)

> **Hint for Step 3**: now that we have a lot of projects in our folder, VS Code is not able to determine which project to pick when deploying via the Azure Tools App Services extension. We first need to publish the project to a local folder and take that as our deployment source. There is already a predefined task for you, called **day2publishScmContacts** (btw, all tasks are defined in the **.vscode** folder). To run it, simply press **F1** and choose **"Tasks: Run Task"**. In the dropdown, select **day2publishScmContacts**. A release build will be started and the outputs placed in the folder **apps/dotnetcore/Scm/Adc.Scm.Api/publish** folder. Choose that folder when "right-click-deploying" from the Azure AppService extension (via "Browse...").

When everything works as expected in Azure, go back to the **settings.js** file of your SPA and adjust the **endpoint** property. Enter the value of your newly deployed API for it, e.g. https://mynewcontactsapi.azurewebsites.net/.

Open the browser and check, if your application still works as expected.

## Finished before Time? ##

Try adding slots to your app and deploy the service to the slot, afterwards swap it!

# Wrap-Up #

We have now set up our local development environment. We cloned the repo, installed dependencies of the SPA, ran both services and deployed the contacts API to Azure.

You can now proceed to the next challenge: [Challenge 2 - Serverless](./challenge-2.md)
