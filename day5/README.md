# Day 5 Identity and Architecture

## Welcome

This day is focusing of implementing authentication and authorization into the Azure Developer College's sample application using Azure Active Directory.

## Challenges

- [Challenge 0: Request an ID Token from Azure AD](./challenges/00-challenge.md)
- [Challenge 1: Receive an ID Token in a Fragment URL](./challenges/01-challenge.md)
- [Challenge 2: OAuth2 Implicit Flow](./challenges/02-challenge.md)
- 💎 [Challenge 3: Azure AD applications and deployment to GitHub environments](./challenges/03-challenge.md) 💎
- 💎 *[Breakout: Integrate the sample application into Azure AD](./challenges/04-breakout.md)* 💎

## Day5 - Goal

You already have deployed the Azure Developer College's sample application to your Azure subscription. Although the application is up and running we can not use different user accounts to create Contacts and VisitReports per user. The current deployed application does not support any user authentication.

Today we we want to integrate _Azure Active Directory_ as an _Identity Provider_ in your application to authenticate and to authorize an Azure AD user to access the sample application.

Azure Active Directory (Azure AD) is Microsoft’s cloud-based identity and access management service, which helps your employees sign in and access resources in:

- External resources, such as Microsoft Office 365, the Azure portal, and thousands of other SaaS applications.
- Internal resources, such as apps on your corporate network and intranet, along with any cloud apps developed by your own organization.

To get started with Azure AD the [documentation](https://docs.microsoft.com/azure/active-directory) is a good starting point.

## Authentication

_Authentication_ is the act of challenging a party for legitimate credentials, providing the basis for creation of a security principal to be used for identity and access control. In simpler terms, it's the process of proving you are who you say you are. Authentication is sometimes shortened to _AuthN_.

## Authorization

_Authorization_ is the act of granting an authenticated security principal permission to do something. It specifies what data you're allowed to access and what you can do with it. Authorization is sometimes shortened to _AuthZ_.

## OpenID Connect and OAuth 2.0

[OpenID Connect](https://openid.net/specs/openid-connect-core-1_0.html) is a simple identity layer built on top of the OAuth 2.0 protocol. OAuth 2.0 defines mechanisms to obtain and use [access tokens](https://docs.microsoft.com/azure/active-directory/develop/access-tokens) to access protected resources, but they do not define standard methods to provide identity information. OpenID Connect implements authentication as an extension to the OAuth 2.0 authorization process. It provides information about the end user in the form of an [id_token](https://docs.microsoft.com/azure/active-directory/develop/id-tokens) that verifies the identity of the user and provides basic profile information about the user.

## Protect APIs with Azure AD

On Day 5 you will learn how you can protect your APIs (microservices) with _Azure AD_. In addition you will learn how _OAuth2 permissions_ are used to grant access to API's client applications and how a signed-in user can grant access. The sample application defines the following OAuth2 permissions

  | OAuth2 permission     | Description                                                         |
  | ----------------------| ------------------------------------------------------------------- |
  | _Contacts.Create_     | Allows the client app to create contacts for the signed-in user     |
  | _Contacts.Read_       | Allows the client app to read contacts of the signed-in user        |
  | _Contacts.Update_     | Allows the client app to update contacts of the signed-in user      |
  | _Contacts.Delete_     | Allows the client app to delete contacts of the signed-in user      |
  | _VisitReports.Create_ | Allows the client app to create VisitReports for the signed-in user |
  | _VisitReports.Read_   | Allows the client app to read VisitReports of the signed-in user    |
  | _VisitReports.Update_ | Allows the client app to update VisitReports of the signed-in user  |
  | _VisitReports.Delete_ | Allows the client app to delete VisitReports of the signed-in user  |

## Sign in users

You will see how the sample application's Single Page Application (SPA) uses _MSAL_ to sign in users and how to acquire an access token to access the APIs in the name of the signed-in user. Once an access token is acquired it is forwarded with each request to the APIs and the APIs can use the token to get needed information about the signed-in user.

## Microsoft Authentication Library

[Microsoft Authentication Library (MSAL)](https://docs.microsoft.com/azure/active-directory/develop/msal-overview) enables developers to acquire tokens from the Microsoft identity platform endpoint in order to access secured Web APIs. These Web APIs can be the Microsoft Graph, other Microsoft APIS, third-party Web APIs, or your own Web API. MSAL is available for .NET, JavaScript, Android and iOS, which support many different application architectures and platforms.

## Architecure

At the end of the day we will have integrated the sample application into Azure AD:

![Architecture Overview](./images/architecture-overview.png)

### Remarks

The challenges marked with the "💎" are the ones that focus on the sample application and represent the adoption of what you have learned in the challenges before.

😎 Enjoy your day! 😎
