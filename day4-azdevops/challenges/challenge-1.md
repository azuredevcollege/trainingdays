# Challenge 1: Plan your first Project Iteration

![Azure Boards](../images/boards.svg)

## Here is what you will learn 🎯

- Configure Iterations for your team
- Plan your work with Azure Boards

In this challenge you will learn how to plan and track your work with _Azure Boards_.

In a software development project people with different responsibilities work together. On the one hand people with a strong business focus and on the other hand people with a strong focus on development and operation. Typically the business people are responsible for defining the road map and features that must be shipped within the next release.

Developers and operators are responsible for implementing the features and to deploy them to the production environment. Hence, it makes sense to provide different views of the state of the running project.

With Azure Boards the product portfolio team can plan features for the next release while developers and operators can break down Features into User Stories and implement them within an iteration.

The agile process provides several _work item types_, _user stories_, _bugs_, _features_, _epics_ and _tasks_.

![workitems](./images/workitems.png)

## Table of Contents

1. [Define Iteration Paths and configure Team Iterations](#define-iteration-paths-and-configure-team-iterations)
2. [Create your first Feature](#create-your-first-feature)
3. [Break the Feature down to User Stories](#break-the-feature-down-to-user-stories)
4. [Break the User Stories down to Tasks](#break-the-user-stories-down-to-tasks)

## Define Iteration Paths and configure Team Iterations

Before we start to plan and track our work we need to define iteration paths. To keep it simple we will define three iterations for the next six weeks. Each iteration will run for two weeks.

Go to **Project settings** -> **Project configuration** to define the _iterations_:

![iterations](./images/iterations.png)

To get started defining iteration paths take a look at the [documentation](https://docs.microsoft.com/en-gb/azure/devops/organizations/settings/set-iteration-paths-sprints?view=azure-devops)

Now we have to select the iterations for the College Team.

Go to **Project settings** -> **Team configurations** select the College Team and add the iterations:

![Team Iterations](./images/team-iterations.png)

## Create your first Feature

Now we start to plan our work for the next challenges, but first let us listen to your product manager:

*"I've assured our management that the sample application of the Azure Developer College will be available on our company's Azure subscription within the next two weeks. Unfortunatley, I didn't have enough time to do this, because our sales department is in a hurry to show the customers that we are Cloud Ready."*

### Start with the first Feature

1. Create your first Feature with the title: *"Deploy ADC's sample application to Azure"*.
2. Set the iteration to *"Iteration 1"*
3. Assign a person that is responsible for the Feature. Ideally this should be your Product Manager

If you need help, take a look at the [documentation](https://docs.microsoft.com/en-gb/azure/devops/boards/backlogs/define-features-epics?view=azure-devops)

## Break the Feature down to User Stories

Create the following User Stories as child items of the Feature, select a person who is responsible for a story and assign all stories to the iteration 1. If you need help, take a look at the [documentation](https://docs.microsoft.com/en-gb/azure/devops/boards/backlogs/define-features-epics?view=azure-devops#add-child-items).

:::tip
📝 To create a hierarchical structure of work items the view **Backlogs** for your College Team is the best one.
:::

Create the following User Stories:

|Title|
|---|
| *S1: As a developer I want to import the ADC's repository to my Azure DevOps Repo and clone the imported repository to my local machine* |
| *S2: As a developer I want to change the title of the ADC's sample application* |
| *S3: As a DevOps Engineer I want to deploy the common infrastructure in Azure* |
| *S4: As a DevOps Engineer I want to build the SCM Contacts API* |
| *S5: As a DevOps Engineer I want to deploy the SCM Contacts API to Azure* |
| *S6: As a DevOps Engineer I want to build the SCM Resources API* |
| *S7: As a DevOps Engineer I want to deploy the SCM Resources API to Azure* |
| *S8: As a DevOps Engineer I want to build the SCM Search API* |
| *S9: As a Devops Engineer I want to deploy the SCM Search API to Azure* |
| *S10: As a DevOps Engineer I want to build the SCM Visitreports API* |
| *S11: As a DevOps Engineer I want to deploy the SCM Visitreports API to Azure* |
| *S12: As a DevOps Engineer I want to build SCM Textanalytics* |
| *S13: As a DevOps Engineer I want to deploy SCM Textanalytics to Azure* |
| *S14: As a DevOps Engineer I want to build the SCM Frontend* |
| *S15: As a DevOps Engineer I want to deploy the SCM Frontend to Azure* |

## Break the User Stories down to Tasks

If you want you can plan your work in more details by breaking down the User Stories to Tasks and assign the Tasks to different members of your Team. To do that switch over to the "Sprint" View of Azure Boards and bring up the Taskboard.

If you have setup everything correctly you should see the following:

![Taskboard](./images/taskboard.png)

[◀ Previous challenge](./challenge-0.md) | [🔼 Day 4](../README.md) | [Next challenge ▶](./challenge-2.md)
