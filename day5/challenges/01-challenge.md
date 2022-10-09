# Challenge 1: Receive an ID Token in a Fragment URL

## Here is what you'll learn 🎯

- How to register an application in Azure AD
- How to create an Open ID Connect request to authenticate an user
- How to receive an ID token in a [Fragment URL](https://en.wikipedia.org/wiki/Fragment_identifier) for receiving information about the authenticated user

This is very similar to [Challenge 0](challenge-0.md), except that this time we will receive the `id_token` through a fragment URL instead of it being in the body.

## Table Of Contents

1. [Create an AAD Application](#create-an-aad-application)
2. [Run the Token Echo Server](#run-the-token-echo-server)
3. [Create an Authentication Request](#create-an-authentication-request)
4. [Wrap-Up](#wrap-up)
5. [Cleanup](#cleanup)

## Create an AAD Application

Before you can authenticate an user you have to register an application in your AAD tenant.

### Azure CLI

```shell
az ad app create --display-name challengeidtokenfragment --web-redirect-uris http://localhost:5001/api/tokenechofragment --identifier-uris https://TENANT_DOMAIN_NAME/challengeidtokenfragment --enable-id-token-issuance true
```
Replace `TENANT_DOMAIN_NAME` with the domain name of your Azure AD instance again.

## Run the Token Echo Server

Open another shell and run the Token Echo Server from [`day5/apps/token-echo-server`](../apps/token-echo-server) in this repository. This helper ASP.NET Core tool is used to echo the token issued by your Azure AD. The tool is listening on port 5001 on your local machine. Tokens are accepted on the route `http://localhost:5001/api/tokenechofragment`. This is why we initially registered an AAD application with a reply url pointing to `http://localhost:5001/api/tokenechofragment`.

```shell
dotnet run
```

## Create an Authentication Request

Replace `TENANT_ID` with your TenantId and `APPLICATION_ID` with your ApplicationId. Open a browser and paste the modified request.

```http
https://login.microsoftonline.com/TENANT_ID/oauth2/v2.0/authorize?
client_id=APPLICATION_ID
&response_type=id_token
&redirect_uri=http%3A%2F%2Flocalhost%3A5001%2Fapi%2Ftokenechofragment
&response_mode=fragment
&scope=openid%20profile
&nonce=1234
```

Copy the `id_token` value from your browser's address bar, go to [https://jwt.ms](https://jwt.ms) and paste the token. Take a minute and have a look at the decoded token.

:::tip
📝 If you need further information about the issued claims take a look [here](https://docs.microsoft.com/azure/active-directory/develop/id-tokens#header-claims).
:::

## Wrap-Up

This challenge showed how to create a new application in Azure AD and how an user can be authenticated using the Open ID Connect protocol. The full process is described [here](https://docs.microsoft.com/azure/active-directory/develop/v2-protocols-oidc).

## Cleanup

Remove the created resources via the Azure CLI:

```shell
az ad app delete --id <APPLICATION_ID>
```

[◀ Previous challenge](./00-challenge.md) | [🔼 Day 5](../README.md) | [Next challenge ▶](./02-challenge.md)
