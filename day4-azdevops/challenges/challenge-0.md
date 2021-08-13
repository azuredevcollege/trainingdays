# Challenge 0: Create an Azure DevOps Organization

<img src="./images/azuredevops.png" width="300" height="200"/>

## Here is what you will learn 🎯

- Create an Azure DevOps account for your organization
- Create a Team Project with an Agile Process Template
- Invite Team members to your organization and projects

## Table of Contents

1. [Azure DevOps](#azure-devops)
2. [Getting started](#getting-started)
3. [Authentication](#authentication)
4. [Create an Azure DevOps Organization](#create-an-azure-devops-organisation)
5. [Create a new Project](#create-a-new-project)
6. [Create a new Team within the Project](#create-a-new-team-within-the-new-project)
7. [Add your Colleagues to the "College Team"](#add-your-colleagues-to-the-college-team)

## Azure DevOps

Azure DevOps provides developer services to support teams to _plan work_, _collaborate_ on code development, and _build and deploy_ applications.
Developers can work in the cloud using Azure DevOps Services or on-premises using Azure DevOps Server. Azure DevOps Server was formerly named Visual Studio Team Foundation Server (TFS).

Azure DevOps provides integrated features that you can access through your web browser or IDE client. You can use one or more of the following services based on your business needs:

- __Azure Repos__ provides Git repositories or Team Foundation Version Control (TFVC) for source control of your code
- __Azure Pipelines__ provides build and release services to support continuous integration and delivery of your apps
- __Azure Boards__ delivers a suite of Agile tools to support planning and tracking work, code defects, and issues using Kanban and Scrum methods
- __Azure Test Plans__ provides several tools to test your apps, including manual/exploratory testing and continuous testing
- __Azure Artifacts__ allows teams to share Maven, npm, and NuGet packages from public and private sources and integrate package sharing into your CI/CD pipelines

## Getting started

To get started with Azure DevOps navigate to the [Azure DevOps overview page](https://azure.microsoft.com/services/devops/). Here you will find further links to the documentation, support, pricing and blogs.

## Authentication

Before we can create an Azure DevOps account we need to understand which Identity Providers are supported by Azure DevOps.
Azure AD, MSA (Microsoft account) and a GitHub account is supported if you want to use cloud authentication. It is recommended to use Azure AD when a large group of users must be managed or if you want to integrate Azure DevOps to your organization's Azure AD, otherwise use your Microsoft or GitHub account.
For on-premises deployments Active Directory is recommended.

:::tip
 📝 If you want to integrate Azure DevOps into your organization's Azure AD make sure that you have the needed permission to create a ServicePrincipal in your Azure AD. We will create a ServicePrincipal in further challenges to authorize Azure DevOps to access your Azure Subscription in order to deploy Azure resources.
:::

## Create an Azure DevOps Organization

1. Navigate to [Azure DevOps](https://azure.microsoft.com/services/devops/)
2. Click "Start for free >", if you don't see a login page, please open a private browser window to make sure that you use the right account (either an Azure AD, MSA or GitHub account).
3. Give your new project a name and select a country/region.
4. Create an organization. Instructions can be found [here](https://docs.microsoft.com/azure/devops/organizations/accounts/create-organization?toc=%2Fazure%2Fdevops%2Fget-started%2Ftoc.json&bc=%2Fazure%2Fdevops%2Fget-started%2Fbreadcrumb%2Ftoc.json&view=azure-devops)

## Create a new Project

Create a new project, name it "College" and use the "Agile" process template.
Instructions can be found [here](https://docs.microsoft.com/azure/devops/organizations/projects/create-project?view=azure-devops).

## Create a new Team within the Project

Create a new team, name it "College Team" and set it as your default team. Instructions can be found [here](https://docs.microsoft.com/azure/devops/organizations/settings/add-teams?view=azure-devops)

## Add your Colleagues to the "College Team"

Now it's time to give your colleagues access to the project and to add them to the "College Team".
Instructions can be found [here](https://docs.microsoft.com/azure/devops/organizations/security/add-users-team-project?view=azure-devops)

[🔼 Day 4](../README.md) | [Next challenge ▶](./challenge-1.md)
