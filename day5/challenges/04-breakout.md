# 💎 Breakout: Deploy the backend services of the sample application 💎

## Here is what you will learn 🎯

In [Challenge 3](./challenge-3.md) we already created the needed Azure AD applications to integrate the sample application into Azure AD. 
The frontend is already deployed to a `dev` and `test` environment on Azure. In this breakout session we will deploy the backend services in the `dev` and `test` environment.

## Table of content 

## Pull latest changes and create a new branch

Since we made changes in the master branch, we first need to pull these changes:

```Shell
git checkout master
git pull
```

Next, we create a new feature branch to prepare the needed changes in the workflows for the backend services:

```Shell
git checkout -b cicd/backend-day5
```

## Prepare the workflows

Open the VS Code workspace `day5.code-workspace` for day5. 

Open the following workflows and replace the organization name in
each job condition with your organization's name:

- day5-scm-contactsapi.yml
- day5-scm-resourcesapi.yml
- day5-scm-searchapi.yml
- day5-scm-visitreports.yml

Commit and push your changes:

```Shell
git add .
git commit -m "deploy backend services"
git push --set-upstream origin cicd/backend-day5
```

Next, do the following:

1. Next, create a Pull request to merge the changes into the master branch
2. Wait until all status checks are successful
3. Merge the Pull request
4. Wait until all services are deployed to the `dev` environment
5. Test the application in the `dev` environment
6. Approve all deployments to the `test` environment
7. Test the application in the `test` environment

## Wrap-Up

🎉 **_Congratulations_** 🎉

You've done it. There is nothing more to add, just test the application and enjoy your success 🥳

[◀ Previous challenge](./challenge-3.md) | [🔼 Day 5](../README.md) |
