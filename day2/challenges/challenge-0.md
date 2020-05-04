# Challenge 0 - Setup your System #

To be able to follow all the challenges provided in this workshop, you need a few prerequisites on your machine. This challenge is for setting up your system.

## dotnet SDK ##

Download and install dotnet core SDK from <https://dotnet.microsoft.com/download>

![dotnet](./img/netcore.png "dotnet")

After the installation, check if everything works as expected. Open a command prompt and execute the dotnet CLI.

```shell
$ dotnet

Usage: dotnet [options]
Usage: dotnet [path-to-application]

Options:
  -h|--help         Display help.
  --info            Display .NET Core information.
  --list-sdks       Display the installed SDKs.
  --list-runtimes   Display the installed runtimes.

path-to-application:
  The path to an application .dll file to execute.
```

## Node JS ##

Download and install the current LTS version (12.y.z) of Node JS from <https://nodejs.org/en/download/>

![nodejs](./img/nodejs.png "nodejs")

Again, after the installtion is complete, check from the command line that everything works as expected.

```shell
$ node --version

v12.14.1

$ npm

Usage: npm <command>

where <command> is one of:
    access, adduser, audit, bin, bugs, c, cache, ci, cit,
    clean-install, clean-install-test, completion, config,
    create, ddp, dedupe, deprecate, dist-tag, docs, doctor,
    edit, explore, fund, get, help, help-search, hook, i, init,
    install, install-ci-test, install-test, it, link, list, ln,
    login, logout, ls, org, outdated, owner, pack, ping, prefix,
    profile, prune, publish, rb, rebuild, repo, restart, root,
    run, run-script, s, se, search, set, shrinkwrap, star,
    stars, start, stop, t, team, test, token, tst, un,
    uninstall, unpublish, unstar, up, update, v, version, view,
    whoami

npm <command> -h  quick help on <command>
npm -l            display full usage info
npm help <term>   search for help on <term>
npm help npm      involved overview
```

## Vue CLI ##

![vuejs](./img/vuejs.png "vuejs")

We will be using VueJS as our frontend framework. Install it from the command line:

```shell
$ npm install -g @vue/cli

[...]
[...]
[...]

$ vue --version

3.8.4
```

## Azure CLI ##

We will also be using the Azure command line interface to create and interact with reosurces running in Azure. To install it, go to <https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest> and choose your platform.

When finished, login to your Azure account from the command line:

```shell
$ az login
You have logged in. Now let us find all the subscriptions to which you have access...
```

A browser window will open, login to Azure and go back to the command prompt. Your active subscription will be shown as JSON, e.g.:

```json
{
  "cloudName": "AzureCloud",
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "isDefault": false,
  "name": "Your Subscription Name",
  "state": "Enabled",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "user": {
    "name": "xxx@example.com",
    "type": "user"
  }
}
```

If you have multiple subscriptions, make sure your are working with the correct one!

```shell
$ az account show
{
  "cloudName": "AzureCloud",
  "id": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "isDefault": false,
  "name": "Your Subscription Name",
  "state": "Enabled",
  "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "user": {
    "name": "xxx@example.com",
    "type": "user"
  }
}
```

If that is not the correct one, follow the steps below:

```shell
$ az account list -o table
[the list of available subscriptions is printed]

$ az account set -s <SUBSCRIPTIONID_YOU_WANT_TO_USE>
```

## Visual Studio Code ##

To work with all the smaples provided in this workshop, you will need an IDE. To target a wide range of developers/architects, we will be using Visual Stduio Code as it runs cross-platform. 

Therefore, go to <https://code.visualstudio.com/docs/setup/setup-overview> and install it on your machine.

### Useful Extensions ###

After the setup is complete. Open Visual Studio an open the "Extensions" sidebar:

![Visual Studio Extensions](./img/vscode_extensions.png "VS Code Extensions")

Search and install the following extensions:

- Azure Tools <https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-node-azure-pack>
- C# <https://marketplace.visualstudio.com/items?itemName=ms-vscode.csharp>
- Debugger for Chrome <https://marketplace.visualstudio.com/items?itemName=msjsdiag.debugger-for-chrome>
- Azure Functions <https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions>

The _Azure Functions_ extension should have already been installed as part of the _Azure Tools_ extension, but you additionally need to make sure to follow the OS-specific instructions.

## Azure Storage Explorer ##

In order to work with Azure Storage Accounts, we will use the Azure Storage Explorer.

Go to <https://azure.microsoft.com/en-us/features/storage-explorer/>, download and install the tool. 

![Azure Storage Explorer](./img/storage_explorer.png "Azure Storage Explorer")

![Azure Storage Explorer](./img/storage_explorer_view.png "Azure Storage Explorer")

## Azure Data Studio ##

We will also work with Azure SQL Databases. You can, of course, use SQL Server Management Studio if you are on a Windows machine. If you want to work "cross-platform", use Azure Data Studio.

Go to <https://docs.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio>, download and install the tool. 

![Azure Data Studio](./img/azure_data_studio.png "Azure Data Studio")

## jq

jq is a lightweight and flexible command-line JSON processor. In some challenges we use jq to process the JSON documents that we get back from Azure CLI.
To install jq got to <https://stedolan.github.io/jq/download/> and follow the instructions.

![jq](./images/../img/jq.png)
