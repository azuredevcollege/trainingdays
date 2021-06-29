# Day 7 Kubernetes

## Welcome

Picking up the container topic of [Day 6](../Day6/README.md) today we will dig deeper into containers and container orchestration and focus on _Kubernetes_.

## Challenges

- [Challenge 0: Setup your System](./challenges/challenge-0.md)
- [Challenge 1: Create your first Kubernetes Cluster](./challenges/challenge-1.md)
- [Challenge 2: Basic Kubernetes Concepts](./challenges/challenge-2.md)
- [Challenge 3: Configuration with Kubernetes - Secrets and ConfigMaps](./challenges/challenge-3.md)
- [Challenge 4: Deploy a Microservice-Oriented Sample Application](./challenges/challenge-4.md)
- [Bonus (optional): Secure Endpoints with SSL Certificates](./challenges/bonus-1.md)

## Goal

The goal of this day is to make you familiar with _Kubernetes_ and give you hands-on experience in deploying real-world applications and services. First, we will setup your local environment that you are ready to use Kubernetes. Then we will setup a first Kubernetes cluster with the _Azure Kubernetes Service_ (AKS).

After a few easy tasks like _deploying_ some containers/pods, this workshop will guide you how to setup deployments and different service types, how to _route traffic_ from the internet to/within your cluster and in the end show you how to _operate_ a real-world application consisting of multiple microservices backed by Azure platform services like Azure SQL DB and/or CosmosDB.

If you have completed Day 1-5 of the Azure Developer College, you are already familiar with the application used today. For all others: the application is called "Simple Contacts Management" and gives a user the ability to manage contacts and visit reports, a very tiny CRM, so to say.

## Result

At the end of the day, you will have a working application that looks like this:

![home](./challenges/images/app_home.png)
![contacts](./challenges/images/app_contacts.png)
![stats](./challenges/images/app_stats.png)

The architecture you will be setting up (in Kubernetes, as well as in Azure) looks like this:

![aks](./challenges/images/aks_arch.png)
