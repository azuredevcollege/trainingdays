# Day 2 Azure Development

## Welcome

This day is about getting your hands dirty with application development in Azure. We will dig into the topics

- Azure Web Application
- Serverless
- Storage
- Messaging

## Challenges

- [Challenge 0:  Setup your system](challenges/challenge-0.md)
- [Challenge 1: Azure Web Applications](challenges/challenge-1.md)
- 💎 *[Breakout 1: Deploy the Azure Dev College sample application to Azure](challenges/challenge-bo-1.md)* 💎
- [Challenge 2: Serverless](challenges/challenge-2.md)
- [Challenge 3 (optional): Messaging](challenges/challenge-3.md)
- 💎 *[Breakout 2: Add a serverless microservice to our sample app and include messaging](challenges/challenge-bo-2.md)* 💎
- 💎 *[Breakout 3 (optional): Create an Azure Web App and Storage Account with ARM templates](challenges/challenge-bo-3.md)* 💎

## Day 2 - Goal

Today is the starting point for the application that we will build and refine during this week. To give you more context on what we will be building, here is the description of our sample application and the resulting architecture for *Day 2*.

### Application

We are going to use the sample application to get to know all the Azure services throughout the workshop. The application is a **Simple Contacts Management** (SCM). You can - surprisingly - create, read, update and delete contacts with it. Currently, we will be storing the contacts in an in-memory database. On *Day 3* we will learn about the various database services of Azure and add proper persistance to our services.

Later that day, we will add a second service to add contact images, which will be stored in an *Azure Storage Account* (Blob). We will also create thumbnails of the images in background via an *Azure Function* which will automatically be triggered through an *Azure Storage Queue*.

The frontend for the application is a small, responsive Single Page Application written in *Vue.js* (which is one of the popular frameworks at the moment). We will be using the cheapest option to host a static website like that namely *Azure Blob storage*.

To make things more tangible, here are some screenshots of the application:

- Welcome page of the app
  ![day2_1](./images/day2_goal1.png "day2_1")
- List of contacts
  ![day2_2](./images/day2_goal2.png "day2_2")
- Detail view of a contact
  ![day2_3](./images/day2_goal3.png "day2_3")

### Architecture

At the end of the day, you will have the following architecture up and running in your own Azure subscription:

![architecture](./images/architecture_day2.png "architecture")

### Remarks

The challenges marked with the "💎" are the ones that focus on the sample application and represent the adoption of what you have learned in the challenges before to the SCM app. They results of the  "💎" challenges will be reused in the next days.

But *do not panic* in case you cannot finish them in time today: we got you covered tomorrow by a baseline deployment of today's results.

😎 Enjoy your day! 😎
