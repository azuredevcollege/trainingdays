# Day 4 Azure DevOps

## Welcome

Today we are going to focus on the topic of _DevOps_. Therefore we wil take a closer look at [Azure DevOps](https://azure.microsoft.com/services/devops/) and its components:

- Azure Boards
- Azure Pipelines
- Azure Repos

## Challenges

- [Challenge 0: Create an Azure DevOps Organisation](challenges/challenge-0.md)
- [Challenge 1: Plan your first Project Iteration](challenges/challenge-1.md)
- [Challenge 2: Working with Azure Repo](challenges/challenge-2.md)
- [Challenge 3: Working with Azure Pipelines](challenges/challenge-3.md)
- [Challenge 4: Build and deploy the SCM Contacts API](challenges/challenge-4.md)
- [Challenge 5: Build and deploy the SCM Frontend](challenges/challenge-5.md)
- 💎 *[Breakout: Create CI/CD Pipelines to deploy the Azure Dev College Sample Application to Azure](challenges/challenge-bo-1.md)* 💎

## Day4 - Goal

You already have deployed the sample application to Azure manually. Today we want to dive into Azure DevOps to show you how you can _automate_ your _build and deployment process_.
In addition we want to show you how you can plan and manage your work with _Azure Boards_ and how you collaborate on code development using Azure Repo.

### Azure Boards

![Azure Boards](./images/boards.svg)

We use _Azure Boards_ to plan your work for Day 4. During the day you will use Azure Boards to define _Features_, _UserStories_ and _Tasks_ to reflect the progress of Day 4.
At the end of the day you will know how to plan and track your work with Azure Boards and how you can plan your agile iterations.

![Goal Azure Boards](./images/goal-azure-boards.png)

### Azure Repos

![Azure Repo](./images/repos.svg)

We use _Azure Repos_ to work with a Git repository. During the day you will work with Git branches, commits and pull requests.

### Azure Pipelines

![Azure Pipelines](./images/pipelines.svg)

We use _Azure Pipelines_ to build and deploy the sample application to a Development and Testing stage on your Azure subscription.
At the end of the day you will know how to create a CI/CD Pipeline for all Microservices of the sample application and how you continuously and consistently deploy services to Azure during your application lifecycle process.

To give you a short overview of all Microservices that are part of the sample application the following table shows you all services and the runtime that is used to implement them.

| Service              | Tech         |
| -------------------- | ------------ |
| SCM Contacts API     | ASP.NET Core |
| SCM Resource API     | ASP.NET Core |
| SCM Search           | ASP.NET Core |
| SCM Visitreports API | NodeJs       |
| SCm Textanalytics    | NodeJs       |
| SCM Frontend         | NodeJs       |

## Remarks

The challenges marked with the "💎" are the ones that focus on the sample application and represent the adoption of what you have learned in the challenges before. They results of the "💎" challenges will be reused in the upcoming days.

But do not panic in case you cannot finish them in time today: we got you covered tomorrow by a baseline deployment.

😎 Enjoy your day! 😎
