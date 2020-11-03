# Deploy the sample application

## Goal / Architecture

We have been working with the Contacts API now for some time, let's deploy the "full-blown" Simple Contacts Management (SCM) app to your Kubernetes cluster. To give you an impression how this will look like in the end, here are some screenshots:

![app_home](./img/app_home.png)
![app_contacts](./img/app_contacts.png)
![app_contacts_details](./img/app_contact_details.png)
![app_stats](./img/app_stats.png)

The application is capable managing contacts and visit reports via a modern, responsive UI that is written in [VueJS](https://vuejs.org). It makes use of several Azure services to have a good UX, e.g. indexing contacts in an [Azure Search service](https://docs.microsoft.com/en-us/azure/search/search-what-is-azure-search) to give users the possiblity to search for contacts anywhere in the app, send visit report results to an [Azure Congitive Service](https://docs.microsoft.com/en-us/azure/cognitive-services/text-analytics/) instance to analyze the sentiment of the result description etc. We also followed a "microservice" approach by giving each service its own data store ([Azure SQL DB](https://docs.microsoft.com/en-us/azure/azure-sql/) for contacts service, [Cosmos DB](https://docs.microsoft.com/en-us/azure/cosmos-db/) for visit reports service etc.). Under the hood, services communicate with each other by sending messages over an [Azure Service Bus](https://docs.microsoft.com/en-us/azure/service-bus-messaging/) instance via several topics so that we can guarantee that each services operates on its own. Some of these messages are also handled by "background/daemon"-services which we implemented by using the [Azure Functions runtime](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-function-linux-custom-image?tabs=bash%2Cportal&pivots=programming-language-csharp) - yes, you can host Azure Functions via Docker containers!

That said, we are also following the best practice to push all possible state of the application out of your cluster. That means, we won't host any database within the cluster. Stateless clusters are much easier to manage!

This is how the architecture looks like after deploying Azure and in-cluster services:

![architecture](./img/aks_arch.png)

## Terraform / Deploy Azure Infrastructure

To create the Azure infrastructure, we are using [Terraform](https://www.terraform.io/), a very popular tool in the "Infrastructure-as-Code" space. If you haven't installed it already, please follow the official tutorial: <https://www.terraform.io/downloads.html>.

If you have successfully installed Terrraform CLI, let's create the Azure service, we need. Go to folder `day7/challenges/samples/challenge-4/0_tf` and open the file `variables.tf`. You need to adjust a few settings:

- default vaule of `location` - choose the same location as your AKS cluster to create all services in the same location
- default value of `prefix` - we use a prefix to have consitent naming of services. Please choose one that fits for you, but be careful to NOT use more than 6 characters for it.

You can leave all other variables with their default values. The file should then look similar to that:

```tf
variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  type    = string
  default = "mydcd7"
  validation {
    condition     = length(var.prefix) <= 6
    error_message = "The prefix value must not be longer than 6 characters."
  }
}

variable "env" {
  type    = string
  default = "dev"
}

variable "cosmosdbname" {
  type    = string
  default = "scmvisitreports"
}

variable "cosmoscontainername" {
  type    = string
  default = "visitreports"
}

variable "sqldbusername" {
  type    = string
  default = "adcsqladmin"
}

variable "sqldbpassword" {
  type    = string
  default = "Ch@ngeMe!123!"
}
```

After adjusting the file, you can execute the following commands (in folder `day7/challenges/samples/challenge-4/0_tf`):

```zsh
$ terraform init
$ terraform apply
# Answer with 'yes' when asked, that the changes will be applied.
```

**This will take up to 20min. to finish** - grab a coffee :) and after the script has successfully finished, save the variables/secrets from Azure to a file:

```zsh
$ terraform output > azure_output.txt
```

## Deploy Configuration / Secrets

Now we have to create two configuration objects that we use to read the Azure configuration within the Kubernetes cluster: a `Secret` and a `ConfigMap`.

Go to `day7/challenges/samples/challenge-4/1_config` and replace the placeholders `#{var_name}#` in the file `secrets.yaml` with the corresponding value from the `azure_output.txt` file.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: scmsecrets
type: Opaque
data:
  'APPINSIGHTSKEY': '#{appinsights_base64}#'
  'CONTACTSLISTENCONNSTR': '#{contacts_listen_connectionstring_base64}#'
  'CONTACTSLISTENENTITYCONNSTR': '#{contacts_listen_with_entity_connectionstring_base64}#'
  'CONTACTSSENDCONNSTR': '#{contacts_send_connectionstring_base64}#'
  'COSMOSENDPOINT': '#{cosmos_endpoint_base64}#'
  'COSMOSPRIMARYKEY': '#{cosmos_primary_master_key_base64}#'
  'RESOURCESCONNECTIONSTRING': '#{resources_primary_connection_string_base64}#'
  'FUNCTIONSCONNECTIONSTRING': '#{funcs_primary_connection_string_base64}#'
  'SEARCHNAME': '#{search_name_base64}#'
  'SEARCHPRIMARYKEY': '#{search_primary_key_base64}#'
  'SQLDBCONNECTIONSTRING': '#{sqldb_connectionstring_base64}#'
  'TAENDPOINT': '#{textanalytics_endpoint_base64}#'
  'TAKEY': '#{textanalytics_key_base64}#'
  'THUMBNAILLISTENCONNSTR': '#{thumbnail_listen_connectionstring_base64}#'
  'THUMBNAILSENDCONNSTR': '#{thumbnail_send_connectionstring_base64}#'
  'VRLISTENCONNSTR': '#{visitreports_listen_connectionstring_base64}#'
  'VRSENDCONNSTR': '#{visitreports_send_connectionstring_base64}#'
```

**IMPORTANT:** The value of a variable should not contain the opening/closing tags anymore, e.g. `'APPINSIGHTSKEY': '1234567890'`.

Do the same with the file `configmap.yaml`.

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  name: uisettings
data:
  settings.js: |-
    var uisettings = {
      endpoint: 'http://#{YOUR_HOST_NAME}#/api/contacts/',
      resourcesEndpoint: 'http://#{YOUR_HOST_NAME}#/api/resources/',
      searchEndpoint: 'http://#{YOUR_HOST_NAME}#/api/search/',
      reportsEndpoint: 'http://#{YOUR_HOST_NAME}#/api/visitreports/',
      enableStats: true,
      aiKey: '#{appinsights}#',
    }
```

The variable `YOUR_HOST_NAME` should be the `nip.io` adress for your ingress controller you used before, e.g. `20-67-122-249.nip.io` in our case here. And **be careful**, in this `ConfigMap` the AppInsights Key is NOT the base64-encoded one!

Please apply both files to your cluster:

```zsh
$ kubectl apply -f configmap.yaml
configmap/uisettings created

$ kubectl apply -f secrets.yaml
secret/scmsecrets created
```

## Build all required Docker images

Now we need to build all Docker images for our application. In total, we will have 8 images in our repository after this task. BTW, for conveniance reasons, we build all images in the container registry!

Now, build all the required images one by one...

1. Contacts API: Folder `day7/apps/dotnetcore/Scm`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-contacts-api:2.0 -f ./Adc.Scm.Api/Dockerfile .
```

2. Resources API: Folder `day7/apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.Api`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-resources-api:2.0 .
```

3. Image Resizer Function: Folder `day7/apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.ImageResizer`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-resources-func:2.0 .
```

4. Search API: Folder `day7/apps/dotnetcore/Scm.Search/Adc.Scm.Search.Api`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-search-api:2.0 .
```

5. Search Indexer Function: Folder `day7/apps/dotnetcore/Scm.Search/Adc.Scm.Search.Indexer`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-search-func:2.0 .
```

6. Visit Reports API: Folder `day7/apps/nodejs/visitreport`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-visitreports-api:2.0 .
```

7. Text Analytics Function: Folder `day7/apps/nodejs/textanalytics`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-textanalytics-func:2.0 .
```

8. Frontend / UI: Folder `day7/apps/frontend/scmfe`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-frontend-ui:2.0 .
```

Now, all images are present in your container registry. You can check the repositories in the portal, if you want:

![acr_portal](./img/acr_portal.png)

## Deploy Backend APIs

We are now all set to deploy the services to the Kubernetes cluster. We will therefor create a new namespace for the application - again, to keep things clearly separated from each other!

**But first**, we need to do some clean-up. We created ingress definitions in `Challenge 2` that would now iterfere with the ones we will be creating in this challenge. So let's cleanup these **OLD INGRESS definitions**:

```zsh
$ kubectl delete ingress ing-frontend
$ kubectl delete ingress ing-contacts
```

### Create a new Kubernetes Namespace

We will put our application into a namespace called `contactsapp`. Let's create it:

```zsh
$ kubectl create ns contactsapp

namespace/contactsapp created
```

We set the new namespace as the current _default one_. Otherwise, we would always have to append `--namespace contactsapp` to our commands.

```zsh
$ kubectl config set-context --current --namespace=contactsapp

Context "adc-cluster" modified.

# to reset the namespace later back to 'default', use 'kubectl config set-context --current --namespace=default'
```

We are ready to deploy the API services (contacts, resources, search, visitreport APIs) to the cluster now. For each of these services, that includes a `Deployment`, a `ClusterIP Service` and an `Ingress` definition.

**For each service, you need to adjust some variables in the predefined YAML manifest. So please carefully read the hints in each API section.**

### Contacts API

Settings to adjust:

| File            | Setting            | Hint                                                             |
| --------------- | ------------------ | ---------------------------------------------------------------- |
| ca-deploy.yaml  | <ARC_NAME>         | Replace with the name of your Azure Container Registry           |
| ca-ingress.yaml | #{YOUR_HOST_NAME}# | Replace with the nip.io domain name, e.g. `20-67-122-249.nip.io` |

<br>

Now apply the definitions. Go to folder `day7/challenges/samples/challenge-4/2_apis`:

```zsh
$ kubectl apply -f 1_contactsapi

deployment.apps/ca-deploy created
ingress.extensions/ing-contacts created
service/contactsapi created
```

### Resources API

Settings to adjust:

| File                   | Setting            | Hint                                                             |
| ---------------------- | ------------------ | ---------------------------------------------------------------- |
| resources-deploy.yaml  | <ARC_NAME>         | Replace with the name of your Azure Container Registry           |
| resources-ingress.yaml | #{YOUR_HOST_NAME}# | Replace with the nip.io domain name, e.g. `20-67-122-249.nip.io` |

<br>

Now apply the definitions. Go to folder `day7/challenges/samples/challenge-4/2_apis`:

```zsh
$ kubectl apply -f 2_resourcesapi

deployment.apps/resources-deploy created
ingress.extensions/ing-resources created
service/resourcesapi created
```

### Search API

Settings to adjust:

| File                | Setting            | Hint                                                             |
| ------------------- | ------------------ | ---------------------------------------------------------------- |
| search-deploy.yaml  | <ARC_NAME>         | Replace with the name of your Azure Container Registry           |
| search-ingress.yaml | #{YOUR_HOST_NAME}# | Replace with the nip.io domain name, e.g. `20-67-122-249.nip.io` |

<br>

Now apply the definitions. Go to folder `day7/challenges/samples/challenge-4/2_apis`:

```zsh
$ kubectl apply -f 3_searchapi

deployment.apps/search-deploy created
ingress.extensions/ing-search created
service/searchapi created
```

### Visit Reports API

Settings to adjust:

| File                      | Setting            | Hint                                                             |
| ------------------------- | ------------------ | ---------------------------------------------------------------- |
| visitreports-deploy.yaml  | <ARC_NAME>         | Replace with the name of your Azure Container Registry           |
| visitreports-ingress.yaml | #{YOUR_HOST_NAME}# | Replace with the nip.io domain name, e.g. `20-67-122-249.nip.io` |

<br>

Now apply the definitions. Go to folder `day7/challenges/samples/challenge-4/2_apis`:

```zsh
$ kubectl apply -f 4_visitreports

deployment.apps/visitreports-deploy created
ingress.extensions/ing-visitreports created
service/visitreportapi created
```

## Deploy Functions / Daemon Services

Next, we deploy the background/daemon services...same procedure:

**For each service, you need to adjust some variables in the predefined YAML manifest. So please carefully read the hints in each API section.**

### Resources / Image Resizer

Settings to adjust:

| File                           | Setting    | Hint                                                   |
| ------------------------------ | ---------- | ------------------------------------------------------ |
| resources-function-deploy.yaml | <ARC_NAME> | Replace with the name of your Azure Container Registry |

<br>

Now apply the definitions. Go to folder `day7/challenges/samples/challenge-4/3_functions`:

```zsh
$ kubectl apply -f 1_resourcesfunc

deployment.apps/resources-function-deploy created
```

### Search / Contacts Indexer

Settings to adjust:

| File                        | Setting    | Hint                                                   |
| --------------------------- | ---------- | ------------------------------------------------------ |
| search-function-deploy.yaml | <ARC_NAME> | Replace with the name of your Azure Container Registry |

<br>

Now apply the definitions. Go to folder `day7/challenges/samples/challenge-4/3_functions`:

```zsh
$ kubectl apply -f 2_searchfunc

deployment.apps/search-function-deploy created
```

### Text Analytics / Visit Reports Sentiment Analysis

Settings to adjust:

| File                               | Setting    | Hint                                                   |
| ---------------------------------- | ---------- | ------------------------------------------------------ |
| textanalytics-function-deploy.yaml | <ARC_NAME> | Replace with the name of your Azure Container Registry |

<br>

Now apply the definitions. Go to folder `day7/challenges/samples/challenge-4/3_functions`:

```zsh
$ kubectl apply -f 3_textanalyticsfunc

deployment.apps/textanalytics-function-deploy created
```

## Deploy UI

Last, but not least, we also need to deploy the VueJS Single Page Application.

Settings to adjust:

| File            | Setting            | Hint                                                             |
| --------------- | ------------------ | ---------------------------------------------------------------- |
| ui-deploy.yaml  | <ARC_NAME>         | Replace with the name of your Azure Container Registry           |
| ui-ingress.yaml | #{YOUR_HOST_NAME}# | Replace with the nip.io domain name, e.g. `20-67-122-249.nip.io` |

<br>

Now apply the definitions. Go to folder `day7/challenges/samples/challenge-4/4_frontend`:

```zsh
$ kubectl apply -f 1_ui

deployment.apps/frontend-deploy created
ingress.extensions/ing-frontend created
service/frontend created
```
