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

## Get started

Now it's time to come back to the Azure Developer College's sample application. We want to introduce a professional CI/CD workflow to coninuously and constantly deploy changes and features to multiple environments. A best practice is to first deploy changes in a separate environment before those changes eventually go live. We can look for potential errors and ensure the quality of our application. Such an environment is usually referred to as the Testing stage. But that is not enough, because it also makes sense to continuously provide the current development status in an environment during the development period. This gives us the opportunity to request feedback from the product owners within a sprint. Such an environment is called the development stage. 

In this challenge we want to start preparing for deployment in two environments. After changes were pushed to the master branch we deploy these changes to the development environment. A deployment to the testing environment is only triggered, after a manual approval. In addition, we want to check within a pull request whether all application components can also be built. These are the status checks of a pull request that we addressed in the last challenge.

![CI/CD Workflow](./images/ci-cd-flow.png)
