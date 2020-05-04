# Day 4 Azure DevOps

- [Challenge 0 - Create an Azure DevOps Organisation](challenges/challenge-0.md)
- [Challenge 1 - Plan your first Project Iteration](challenges/challenge-1.md)
- [Challenge 2 - Working with Azure Repo](challenges/challenge-2.md)
- [Challenge 3 - Working with Azure Pipelines](challenges/challenge-3.md)
- [Challenge 4 - Working with Azure Pipelines](challenges/challenge-4.md)
- :small_orange_diamond: *[Breakout! - Create CI/CD pipelines to deploy the Azure Dev College sample application to Azure](challenges/challenge-bo-1.md)* :small_orange_diamond:

# Day4 - Goal

You already have deployed the sample application to Azure manually. Today we want to dive into Azure DevOps to show you how you can automate your build and deployment process.
In addition we want to show you how you can plan and manage your work with Azure Boards and how you collaborate on code development using Azure Repo.

## Azure Boards

![Azure Boards](./challenges/images/boards.svg)

We use Azure Boards to plan your work for Day4. During the day you will use Azure Boards to define Features, UserStories and Tasks to reflect the progress of Day4.
At the end of the day you will know how to plan and track your work with Azure Boards and how you can plan your agile iterations.

![Goal Azure Boards](./challenges/images/goal-azure-boards.png)

## Azure Repos

![Azure Repo](./challenges/images/repos.svg)

We use Azure Repo to work with a Git repository. During the day you will work with Git branches, commits and PullRequests.

## Azure Pipelines

![Azure Pipelines](./challenges/images/pipelines.svg)

We use Azure Pipelines to build and deploy the sample application to a Development and Testing stage on your Azure subscription.
At the end of the day you will know how to create a CI/CD Pipeline for all Microservices of the sample application and how you continuously and consistently deploy services to Azure during your application lifcycle process.

To give you a short overview of all Microservices that are part of the sample application the following table shows you all services and the runtime that is used to implement the service.

|Service| Tech|
|-------|-----|
|SCM Contacts API|ASP.NET Core|
|SCM Resource API|ASP.NET Core|
|SCM Search|ASP.NET Core|
|SCM Visitreports API|NodeJs|
|SCm Textanalytics|NodeJs|
|SCM Frontend|NodeJs|


