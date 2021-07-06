# Challenge 04: Import the Azure Developer College's repository and set branch rules

⏲️ *Est. time to complete: 10 min.* ⏲️

## Here is what you will learn 🎯

In this challenge you will learn how to:

- Import the Azure Developer College's repository into your organization
- Set branch rules to require reviewers


## Table Of Contents

1. [Import the Azure Developer College's repository into your organization](#import-the-azure-developer-colleges-repository-into-your-organization)


## Import the Azure Developer College's repository into your organization

In the last challenges we have learned a lot about tGitHub features and Azure bicep. Now it's time to come back to the Azure Developer College's sample application and connect the dots. In the next challenges and breakout sessions we want to show you how to use a CI/CD workflow to deploy the sample application to Azure using GitHub Actions workflows. All Azure bicep and GitHub Actions workflows are already available in the Azure Developer College's repository. Don't worry you don't have to implement all parts to create a professional CI/CD workflow. We just need to import the repository into your GitHub organisation. So, let us start!

Navigate to your GitHub organisation and go to the section _Repositories_ and create a new repository. In the _New repository_ form click the _Import a repository_ link.

![GitHub import repository](./images/gh-import-repo.png)

In the _Import your project to GitHub_ view, we need to specify the URL of the repository we want to import. 
This is the URL of the Azure Developer College traningdays' https://github.com/azuredevcollege/trainingdays. 
Use the name _trainingdays_ as repository name.

::: danger
🛑 Be careful and use the right owner for the repository you want to import !
:::

We need to make the repository public as we want to set _Branch rules_ later in this challenge. Branch rules are only available for public repositories in the free tier.
After all values are set, we can start the import.

![GitHub import repository view](./images/gh-import-repo-view.png)



