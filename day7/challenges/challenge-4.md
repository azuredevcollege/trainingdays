# Deploy the sample application

## Architecture

## Terraform / Deploy Azure Infrastructure

Got to folder: `day7/challenges/samples/challenge-4/0_tf`.

Execute:

```zsh
$ terraform init
$ terraform apply
# Answer with 'yes' when asked, if the changes should be applied.

# Save variables/secrets from Azure to a file
$ terraform output > azure_output.txt
```

## Deploy Configuration / Secrets

Go to `day7/challenges/samples/challenge-4/1_config` and replace the placeholders `#{var_name}#` in `secrets.yaml` with the corresponding value in the `azure_output.txt` file.

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

**IMPORTANT:** The value of a variable should not contain the opening/closing tags (e.g. `'APPINSIGHTSKEY': '1234567890'`) anymore.

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

The variable `YOUR_HOST_NAME` should be the `nip.io` adress for your ingress controller you used before, e.g. `20-67-122-249.nip.io` in our case here.

## Build all required Docker images

We build all images in the container registry!

Go to folder `day7/apps/dotnetcore/Scm` and execute:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-contacts-api:2.0 -f ./Adc.Scm.Api/Dockerfile .
```

Folder `day7/apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.Api`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-resources-api:2.0 .
```

Folder `day7/apps/dotnetcore/Scm.Resources/Adc.Scm.Resources.ImageResizer`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-resources-func:2.0 .
```

Folder `day7/apps/dotnetcore/Scm.Search/Adc.Scm.Search.Api`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-search-api:2.0 .
```

Folder `day7/apps/dotnetcore/Scm.Search/Adc.Scm.Search.Indexer`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-search-func:2.0 .
```

Folder `day7/apps/nodejs/visitreport`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-visitreports-api:2.0 .
```

Folder `day7/apps/nodejs/textanalytics`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-textanalytics-func:2.0 .
```

Folder `day7/apps/frontend/scmfe`:

```zsh
$ az acr build -r <ACR_NAME> -t <ACR_NAME>.azurecr.io/adc-frontend-ui:2.0 .
```

## Deploy Backend APIs

### Create separate namespace

```zsh
$ kubectl create ns contactsapp

namespace/contactsapp created
```

Set the new namespace as the current default one. Otherwise, we would always have to append `--namespace contactsapp` to our commands.

```zsh
$ kubectl config set-context --current --namespace=contactsapp

Context "adc-cluster" modified.

# to reset the namespace later back to 'default': kubectl config set-context --current --namespace=default
```

**CLEANUP OLD INGRESS**:

```zsh
$ kubectl delete ingress ing-frontend
$ kubectl delete ingress ing-contacts
```

### Contacts API

Folder `day7/challenges/samples/challenge-4/2_apis/1_contactsapi`:

```


### Resources API

### Search API

### Visit Reports API

## Deploy Functions / Daemon Services

### Resources / Image Resizer

### Search / Contacts Indexer

### Text Analytics / Visit Reports Sentiment Analysis

## Deploy UI
```
