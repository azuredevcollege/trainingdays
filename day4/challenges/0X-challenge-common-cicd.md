# Challenge 01: Create a CI/CD workflow to deploy the common used Azure resources of the SCM sample application

⏲️ _Est. time to complete: 30 min._ ⏲️

## Here is what you will learn 🎯

In this challenge you will learn how to:

- Create a GitHub CI/CD workflow to deploy common used Azure resources of the SCM sample application
- Add approval reviewer to a pull request
- See a pull requests status checks in action
- Deploy changes to the master branch to a development environment
- Approve deployment requests to a Testing environment

## Table of content

1. [Get started](#get-started)
2. [Goal](#goal)
3. [Plan your work](#plan-your-work)

## Get started

Now it's time to come back to the Azure Developer College's sample application. We want to introduce a professional CI/CD workflow to coninuously and constantly deploy changes and features to multiple environments. A best practice is to first deploy changes in a separate environment before those changes eventually go live. We can look for potential errors and ensure the quality of our application. Such an environment is usually referred to as the Testing stage. But that is not enough, because it also makes sense to continuously provide the current development status in an environment during the development period. This gives us the opportunity to request feedback from the product owners within a sprint. Such an environment is called the development stage. 

In this challenge we want to start preparing for deployment in two environments. After changes were pushed to the master branch we deploy these changes to the development environment. A deployment to the testing environment is only triggered, after a manual approval. In addition, we want to check within a pull request whether all application components can also be built. These are the status checks of a pull request that we addressed in the last challenge.

The following graphic illustrates the wortkflow:

![CI/CD Workflow](./images/ci-cd-flow.png)

The sample application is composed of various microservices. Each service belongs to a bounded context of the SCM domain. A bounded context defines its own domain model and it comprises the business logic for a specific technical area of the application. The SCM sample application consist of the following bounded contexts:

![Domain Driven Design bounded contexts](./images/ddd-bounded-contexts.png)

Each context provides an API which the frontend accesses and presents the domain to the user:

![Frontend accesses APIs](./images/frontend-apis.png)

A bounded context should be the responsibility of a single team. However, a team can also be responsible for several bounded contexts, but it is not recommended that several teams work on one bounded context. 

What does this mean for our CI/CD workflow?

Regardless of the teams, we should be able to roll out each bounded context independently. This way we reduce the time for deployment, as the complete application does not have to be deployed. We can implement independent release cycles and roll out targeted features and fixes. However, this approach also supports the development of an application by several teams.

Later in the day we will create the following CI/CD workflows to deploy to a development and testing environment:
- scm-contactsapi
- scm-resourcesapi
- scm-searchapi
- scm-visitreportapi
- scm-frontend

In the SCM sample application's architecture no service within a bounded context communicates directly with services from another bounded context. Instead changes to a domain object within a bounded context are published through events, which describe that changes. Technically, a message bus is used to notify other bounded contexts about the changes. With this approach we can decouple the bounded contexts. Decoupling increases the availability of our application, because when a request is made to the API, not all services have to be addressed. A bounded context is informed of changes via the message bus. These changes can then be processed asynchronously and the own domain model can be updated. This approach is also used within a bounded context. The Resource Context for example, stores uploaded images in an Azure blob first an uses a message queue to notify the image resizer that a new image is available. The image resizer loads the image asynchronously in the background and creates a thumbnail of the image. 

## Goal

The goal of this challenge is to create a CI/CD workflow for shared Azure resources. Before we can deploy all other services we need to create a set of Azure resources, which are used by all services. We will create the necessary GitHub Actions workflow. Don't worry, the workflow is already created, but we need to take a few steps to activate it. This will also give us the opportunity to introduce GitHub environments and understand how a pull request workflow works, including status checks and reviewers. At the end of this challenge we will have created one Azure resource group for each environment (Dev, Test). Each resource group contains the shared components:

- **Azure ApplicationInsights**, to get a contnuous monitoring of the application
- **Azure ServiceBus**, used to transport events from one bounded context to another and for events within a bounded context
- **AppServicePlan Windows**, for Windows based workloads
- **AppServicePlan Linux**, for Linux base workloads
- **Consumption based AppServicePlan Windows**, for Windows based Azure Functions
- **Storage Account**, needed for Azure Functions
- **Cosmos DB Account**, account for Cosmos DB

## Plan your work

First we want to reflect our work for this challenge in the project board. 