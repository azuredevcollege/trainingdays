# Challenge 3: Configuration with Kubernetes - Secrets and ConfigMaps

## Here is what you will learn 🎯

 In this challenge you will learn how to configure your application from outside by using standard Kubernetes objects. In detail you will learn how to use `ConfigMaps` and `Secrets`.

## Table Of Contents

1. [Why do we need Secrets and ConfigMaps](#why-do-we-need-secrets-and-configmaps)
2. [ConfigMaps](#configmaps)
3. [Secrets](#secrets)
4. [Configure the Demo Application with ConfigMap and Secrets](#configure-the-demo-application-with-configmap-and-secrets)

## Why do we need Secrets and ConfigMaps

It is actually obvious that certain settings of an application or service should not be hard coded in the source code of the application. Instead applications load these settings from a _configuration file_ at _runtime_ to avoid a new build of the application or service.

By configuration files an application can be integrated configurable into other environments.

::: tip
📝 Configuration files are not the only possibility to configure applications. _Environment variables_ are even more frequently used to configure an application or service.
:::

Your containerized applications need certain data or credentials to run properly. In [challenge 2](./challenge-2.md) you have seen that running an SQL Server in a container you had to set a password, which was hard coded into the deployment file:

```yaml
...
containers:
- name: mssql
    image: mcr.microsoft.com/mssql/server:2019-latest
    ports:
    - containerPort: 1433
    env:
    - name: MSSQL_PID
        value: 'Developer'
    - name: ACCEPT_EULA
        value: 'Y'
    - name: SA_PASSWORD
        value: 'Ch@ngeMe!23'
```

This is a bad approach. It is _not_ possible to use the same definition in another hosting environment without setting a new password (unless you always use the same password, which of course is a no go).

Data such as a password are sensitive data and should be treated with special care. Sensitive data should be stored in a _secret store_ to which only a certain group of users has access to. With a secret store, developers do not have to store sensitive data in source code.

The definition of a Kubernetes deployment is definitely part of the source code.

In [challenge 2](./challenge-2.md) we created a deployment for the Contacts API. The API loads the connection string to the hosted SQL Server from an environment variable `ConnectionStringsDefaultConnectionString\_\_`. The connection string's value is hard coded, too.

```yaml
containers:
- name: myapi
    env:
    - name: ConnectionStrings__DefaultConnectionString
        value: Server=tcp:<IP_OF_THE_SQL_POD>,1433;Initial Catalog=scmcontactsdb;Persist Security Info=False;User ID=sa;Password=Ch@ngeMe!23;MultipleActiveResultSets=False;Encrypt=False;TrustServerCertificate=True;Connection Timeout=30;
    image: <ACR_NAME>.azurecr.io/adc-api-sql:1.0
```

Currently, we have the Contacts API, the SQL Server and the front-end running in the cluster. Looking back at how the front-end was deployed, some of you may have wondered if this is the right way to update the configuration in source code and build a new container.

The answer is of course: _No_.

The configuration for the front-end which is simply a JavaScript file must be somehow configured at deployment time not at the build time of the container. We need to be able to place the following file content into the container at deployment time:

```js
var uisettings = {
  endpoint: 'http://<YOUR_NIP_DOMAIN>/api/contacts/',
  enableStats: false,
  aiKey: '',
}
```

With _Secrets_ and _ConfigMap_, Kubernetes provides two objects that help us to configure applications or services at deployment time. In the next sections we will get to know these objects better.

## ConfigMaps

A _ConfigMap_ is a Kubernetes API object used to store non confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables or as configuration files in volume mounts.

A ConfigMap allows you to decouple environment specific settings from your deployments and pod definitions or containers.

You can use `kubectl create configmap` command to create ConfigMaps from directories, files and literal values.

### Create a ConfigMap from iteral values

Now, let us first create a ConfigMap from literal values and let us look at how the ConfigMap object is built up.

Open a shell and run the `kubectl create configmap` command with the option `--from-literal` argument to define a literal value from the command line:

```shell
kubectl create configmap myfirstmap --from-literal=myfirstkey=myfirstvalue --from-literal=mysecondkey=mysecondvalue --dry-run=client -o yaml
```

After the command has been executed, you will see the following output:

```yaml
apiVersion: v1
data:
  myfirstkey: myfirstvalue
  mysecondkey: mysecondvalue
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: myfirstmap
```

In the data section of the object you can see that each key is mapped to a value. So far so good. But how can these key-value pairs be accessed in a Pod or Deployment definition?

Let's first see how to use the key-value pairs in environment variables.

First, create the ConfigMap with the name `myfirstmap`:

```shell
kubectl create configmap myfirstmap --from-literal=myfirstkey=myfirstvalue --from-literal=mysecondkey=mysecondvalue
```

If you want, you can use kubectl describe configmap to see how the ConfigMap is created:

```shell
kubectl describe configmap myfirstmap
```

Now create a file named `myfirstconfigmapdemo.yaml`and add the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: myfirstconfigmapdemo
  name: myfirstconfigmapdemo
spec:
  containers:
    - image: alpine
      name: myfirstconfigmapdemo
      command: ['sleep', '3600']
      env:
        - name: MYFIRSTVALUE
          valueFrom:
            configMapKeyRef:
              name: myfirstmap
              key: myfirstkey
        - name: MYSECONDVALUE
          valueFrom:
            configMapKeyRef:
              name: myfirstmap
              key: mysecondkey
  restartPolicy: Never
```

In the definition you can see that we set the value for an environment variable by referencing the key of a ConfigMap.

Now deploy the definition:

```shell
kubectl apply -f myfirstconfigmapdemo.yaml
```

To check if everything is setup correctly we can use the `kubectl exec` command to print all environment variables of the pod.

```shell
kubectl exec myfirstconfigmapdemo -- /bin/sh -c printenv
...
MYFIRSTVALUE=myfirstvalue
MYSECONDVALUE=mysecondvalue
...
```

We have seen how you can reference values in a ConfigMap and use them as environment variable.

Before we continue with the next exercise and see how we can add ConfigMap's key and value pairs as files in a read-only volume, remove the deployed pod from your cluster:

```shell
kubectl delete pod myfirstconfigmapdemo
```

Kubernetes supports many types of volumes. A pod can use any number of volume types simultaneously. At its core, a volume is just a directory which is accessible to the container in a pod.

How that directory comes to be a medium is determined by the particular volume type. At the end the volume must be mounted in the container to access it. A ConfigMap provides a way to inject configuration data into pods. The data stored in a ConfigMap can be referenced in a volume of type configMap and then consumed by containerized applications running in a pod.

Let us see it in action. First create a new file and name it `volumedemo.yaml` and add the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: volumedemo
  name: volumedemo
spec:
  containers:
    - image: alpine
      name: volumedemo
      command: ['sleep', '3600']
      volumeMounts:
        # mount the config volume to path /config
        - name: config
          mountPath: '/config'
          readOnly: true
  volumes:
    # set volumes at the Pod level, then mount them into containers inside the pod
    - name: config
      configMap:
        # specify the name of the ConfigMap to use
        name: myfirstmap
        # an array of keys from the ConfigMap to create as file
        items:
          - key: 'myfirstkey'
            path: 'myfirstkey'
          - key: 'mysecondkey'
            path: 'mysecondkey'
```

Use `kubectl apply` command to create the Pod in your cluster:

```shell
kubectl apply -f ./volumedemo.yaml
```

Next we can connect to the container by running the `kubectl exec` command with argument `-it` and open a shell inside the container:

```shell
kubectl exec -it volumedemo -- /bin/sh
```

Now in the shell check the directory `/config`:

```shell
$ ls /config
myfirstkey   mysecondkey
$ more /config/myfirstkey
myfirstvalue
```

All ConfigMap keys, specified in the items array of the pod definition, are created as files in the mounted volume and accessible to the container.

### Create a ConfigMap from file

In the previous exercise we have seen how key-value pairs are added to a ConfigMap using `--from-literal`. A ConfigMap's key-value pairs can be created from files, too.

In this exercise we learn how to create ConfigMap key-value pairs from files and how to mount a volume to make these files accessibly to the container inside a pod.

First we need a file that contains the settings for a container. Create a file `demosettings.json` and add the following content:

```json
{
  "key1": "value1",
  "key2": "value2"
}
```

We can use the `kubectl create configmap` command with argument `--from-file` to create a key-value pair from a file.

Let us first try a dry-run to see how the ConfigMap object looks like:

```shell
$ kubectl create configmap myfilemap --from-file=demosettings=./demosettings.json --dry-run=client -o yaml

apiVersion: v1
data:
  demosettings: |-
    {
        "key1" : "value1",
        "key2" : "value2"
    }
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: myfilemap
```

The ConfigMap contains a key-value pair with key `demosettings` with the JSON file's content as value. Since the name of the key was specified with `demosettings` in `--from-file` it is the expected result. But it is also possible to leave out the name of the key.

The name of the key will then be the name of the file.

```shell
$ kubectl create configmap myfilemap --from-file=./demosettings.json --dry-run=client -o yaml

apiVersion: v1
data:
  demosettings.json: |-
    {
        "key1" : "value1",
        "key2" : "value2"
    }
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: myfilemap
```

Now let us first create the ConfigMap in the cluster:

```shell
kubectl create configmap myfilemap --from-file=demosettings=./demosettings.json
```

Create a file `volumefiledemo.yaml` and add the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: volumefiledemo
  name: volumefiledemo
spec:
  containers:
    - image: alpine
      name: volumefiledemo
      command: ['sleep', '3600']
      volumeMounts:
        # mount the config volume to path /config
        - name: config
          mountPath: '/config'
          readOnly: true
  volumes:
    # set volumes at the Pod level, then mount them into containers inside the pod
    - name: config
      configMap:
        # specify the name of the ConfigMap to use
        name: myfilemap
        # an array of keys from the ConfigMap to create as file
        items:
          - key: 'demosettings'
            path: 'demosettings.json'
```

This pod definition mounts the volume `config` to the path `/config` into the container. The volume is of type `configMap` and references the ConfigMap `myfilemap`.

The content or value of the key `demosettings` is stored in a file named `demosettings.json` which is accessibly to the container under `/config/demosettings.json`.

Let us see it in action. Use the `kubectl apply` command to create the pod:

```shell
kubectl apply -f ./volumefiledemo.yaml
```

After the pod is up and running we can use the `kubectl exec` command with argument `-it` to connect to the container inside the pod and open a shell:

```shell
kubectl exec -it volumefiledemo -- /bin/sh
```

Now we can check if the file and its content is available:

```shell
$ ls /config
demosettings.json
$ more /config/demosettings.json
{
    "key1" : "value1",
    "key2" : "value2"
}
```

## Secrets

_ConfigMaps_ are used to creating _configuration settings_ for applications as _plain text_. The Kubernetes' _Secret_ object is similar to a ConfigMap except that the value of a key value pair is _base64_ encoded. It is therefore suitable for storing sensitive data like passwords or connection strings.

A pure base64 encoding of course does not offer the best possible protection for sensitive data as it is very easy to decode a base64 encoded value. It is therefore better to use a key vault like the Azure KeyVault. But since the Secret object is a Kubernetes object the access to these objects can be controlled by the Kubernetes _Role-based access control_ (RBAC) system (see [Using RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) for details).

### Create a Secret for literal values

Let us first create a Secret from literal values and let us look at how the Secret object is built up. Open a shell and run the kubectl create configmap command with the option `--from-literal` argument to define a literal value from the command line:

```shell
kubectl create secret generic mysecret --from-literal=myfirstkey=myfirstvalue --from-literal=mysecondkey=mysecondvalue --dry-run=client -o yaml
```

After the command has been executed, you see the following output:

```yaml
apiVersion: v1
data:
  myfirstkey: bXlmaXJzdHZhbHVl
  mysecondkey: bXlzZWNvbmR2YWx1ZQ==
kind: Secret
metadata:
  creationTimestamp: null
  name: mysecret
```

In the data section of the object you can see that each key is mapped to a value and the value is base64 encoded. So, how can these key-value pairs be accessed in a Pod or Deployment definition?

Let's first see how to use the key-value pairs in environment variables.

First, create the Secret with the name `mysecret`:

```shell
kubectl create secret generic mysecret --from-literal=myfirstkey=myfirstvalue --from-literal=mysecondkey=mysecondvalue
```

If you want, you can use kubectl describe secret to see how it is created:

```shell
kubectl describe secret mysecret
```

If you want to see the encoded values you can do the following:

```shell
kubectl get secret mysecret --output="jsonpath={.data}"

```

Now create a file with the name `mysecretdemo.yaml`and add the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: mysecretdemo
  name: mysecretdemo
spec:
  containers:
    - image: alpine
      name: mysecretdemo
      command: ['sleep', '3600']
      env:
        - name: MYFIRSTVALUE
          valueFrom:
            secretKeyRef:
              name: mysecret
              key: myfirstkey
        - name: MYSECONDVALUE
          valueFrom:
            secretKeyRef:
              name: mysecret
              key: mysecondkey
  restartPolicy: Never
```

In the definition you can see that we set the value for an environment variable by referencing the key of a secret.

Now deploy the definition:

```shell
kubectl apply -f mysecretdemo.yaml
```

To check if everything is setup correctly we can use the `kubectl exec` command to print all environment variables of the pod:

```shell
$ kubectl exec mysecretdemo -- /bin/sh -c printenv
...
MYFIRSTVALUE=myfirstvalue
MYSECONDVALUE=mysecondvalue
...
```

The environment variables are set correctly and the values were set decoded.

We have seen how you can reference values in a Secret and use them as environment variable.

Before we continue with the next exercise and see how we can add Secret's key and value pairs as files in a read-only volume, remove the deployed pod from your cluster:

```shell
kubectl delete pod mysecretdemo
```

### Create a Secret from file

In the previous exercise we have seen how key-value pairs are added to a Secret using `--from-literal`. A Secret's key-value pairs can be created from files, too.

In this exercise we learn how to create Secret's key-value pairs from files and how to mount a volume to make these files accessibly to the container inside a pod.

First we need a file that contains the settings for a container. Create a file `demosecrets.json` and add the following content:

```json
{
  "key1": "value1",
  "key2": "value2"
}
```

We can use the `kubectl create secret generic` command with argument
`--from-file` to create a key-value pair from a file.

Let us first try a dry-run to see how the ConfigMap object looks like:

```shell
$ kubectl create secret generic myfilesecret --from-file=demosecrets=./demosecrets.json --dry-run=client -o yaml

apiVersion: v1
data:
  demosecrets: ewogICAgImtleTEiIDogInZhbHVlMSIsCiAgICAia2V5MiIgOiAidmFsdWUyIgp9
kind: Secret
metadata:
  creationTimestamp: null
  name: myfilesecret
```

The Secret contains a key-value pair with key `demosecretes` with the JSON file's base64 encoded content. Since the name of the key was specified with `demosecrets` in `--from-file` it is the expected result.

But it is also possible to leave out the name of the key. The name of the key will then be the name of the file.

```shell
$ kubectl create secret generic myfilesecret --from-file=./demosecrets.json --dry-run=client -o yaml

apiVersion: v1
data:
  demosecrets.json: ewogICAgImtleTEiIDogInZhbHVlMSIsCiAgICAia2V5MiIgOiAidmFsdWUyIgp9
kind: Secret
metadata:
  creationTimestamp: null
  name: myfilesecret
```

Now let us first create the Secret in the cluster:

```shell
kubectl create secret generic myfilesecret --from-file=demosecrets=./demosecrets.json
```

Create a file `volumesecretdemo.yaml` and add the following content:

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: volumesecretdemo
  name: volumesecretdemo
spec:
  containers:
    - image: alpine
      name: volumesecretdemo
      command: ['sleep', '3600']
      volumeMounts:
        # mount the config volume to path /config
        - name: config
          mountPath: '/config'
          readOnly: true
  volumes:
    # set volumes at the Pod level, then mount them into containers inside the pod
    - name: config
      secret:
        # specify the name of the secret to use
        secretName: myfilesecret
        # an array of keys from the Secret to create as file
        items:
          - key: 'demosecrets'
            path: 'demosecrets.json'
```

This pod definition mounts the volume `config` to the path `/config` into the container. The volume is of type `secret` and references the Secret `myfilesecret`.

The content or value of the key `demosecrets` is stored in a file named `demosecrets.json` which is accessibly to the container under `/config/demosecrets.json`.

Let us see it in action. Use the `kubectl apply` command to create the pod:

```shell
kubectl apply -f ./volumesecretdemo.yaml
```

After the pod is up and running we can use the `kubectl exec` command with
argument `-it` to connect to the container inside the pod and open a shell:

```shell
kubectl exec -it volumesecretdemo -- /bin/sh
```

Now we can check if the file and its content is available:

```shell
$ ls /config
demosecrets.json
$ more /config/demosecrets.json
{
    "key1" : "value1",
    "key2" : "value2"
}
```

## Configure the demo application with ConfigMap and Secrets

Now it's time to configure the application which we have deployed in [challenge 2](./challenge-2.md) with ConfigMaps and Secrets:

- The SQL Server, the Contacts API and the front-end are still running in the cluster. We will create a _ConfigMap_ to configure the front-end correctly to set the endpoint to access the Contacts API.
- A _Secret_ will be created to store the password for the SQL Server and the connection string to the server which is needed by the Contacts API.

### Configure the front-end with a ConfigMap

In [challenge 2](./challenge-2.md) we have adjusted already the needed `settings.js` file for the front-end and have entered the endpoint of the Contacts API (the file is located under `day7/apps/frontend/scmfe/public/settings`).

```js
var uisettings = {
  endpoint: 'http://<YOUR_NIP_DOMAIN>/api/contacts/',
  // "resourcesEndpoint": "https://adcday3scmresourcesapi-dev.azurewebsites.net/",
  // "searchEndpoint": "https://adcday3scmrsearchapi-dev.azurewebsites.net/",
  // "reportsEndpoint": "https://adcday3scmvr-dev.azurewebsites.net",
  enableStats: false,
  aiKey: '',
}
```

Your current file should look something like that, because you have already specified your nip domain:

```js
var uisettings = {
  endpoint: 'http://20-67-122-249.nip.io/api/contacts/',
  enableStats: false,
  aiKey: '',
}
```

Create a ConfigMap by using the `kubectl create config map` command and argument `--from-file`. Make sure that you use the right path to the settings file:

```shell
kubectl create configmap frontend-settings --from-file=./day7/apps/frontend/scmfe/public/settings/settings.js
```

Now we have to adjust the front-end's deployment definition to mount the file from a volume.

Open your front-end deployment file and add the needed volume and volume mount:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myfrontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myfrontend
  template:
    metadata:
      labels:
        app: myfrontend
    spec:
      containers:
        - name: myfrontend
          image: <ACR_NAME>.azurecr.io/adc-frontend-ui:1.0
          resources:
            limits:
              memory: '128Mi'
              cpu: '500m'
          ports:
            - containerPort: 80
          volumeMounts:
            # mount the config volume to path /usr/share/nginx/html/settings
            - name: frontend-settings
              mountPath: '/usr/share/nginx/html/settings'
              readOnly: true
      volumes:
        # set volumes at the Pod level, then mount them into containers inside the pod
        - name: frontend-settings
          configMap:
            # specify the name of the ConfigMap to use
            # we dont't need to specify an array of keys to add as file from the ConfigMap
            # as the name of the key is settings.js the file is created as settings.js
            name: frontend-settings
```

Now use the `kubectl apply` command to update the frontend deployment:

```shell
kubectl apply -f ./frontend.yaml
```

Open a browser and check if the front-end is still working.

### Configure the SQL Server and Contacts API with a Secret

In [challenge 2](./challenge-2.md) we have set the SQL Server's admin password as plain text in an environment variable. The connection string to access the SQL Server was set in an environment variable of the Contacts API's deployment file as plain text, too.

Now we create a Kubernetes Secret to store both sensitive data and inject the as environment variable into each deployments.

First, we have to create a secret that contains the SQL Server's password and connection string. Therefore we use the `kubectl create secret generic` command and create the key value pairs with the argument `--from-literal`:

```shell
kubectl create secret generic sqlsecrets --from-literal=pwd="Ch@ngeMe!23" --from-literal=constr="Server=tcp:mssqlsvr,1433;Initial Catalog=scmcontactsdb;Persist Security Info=False;User ID=sa;Password=Ch@ngeMe!23;MultipleActiveResultSets=False;Encrypt=False;TrustServerCertificate=True;Connection Timeout=30;"
```

Now we can inject the SQL Server's password in the SQL Server's deployment file:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mssql-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mssql
  template:
    metadata:
      labels:
        app: mssql
    spec:
      terminationGracePeriodSeconds: 30
      securityContext:
        fsGroup: 10001
      containers:
        - name: mssql
          image: mcr.microsoft.com/mssql/server:2019-latest
          ports:
            - containerPort: 1433
          env:
            - name: MSSQL_PID
              value: 'Developer'
            - name: ACCEPT_EULA
              value: 'Y'
            - name: SA_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: sqlsecrets
                  key: pwd
```

Update your SQL Server's deployment using the `kubectl apply` command:

```shell
kubectl apply -f ./sqlserver.yaml
```

After that we can update the Contact API's deployment to inject the connection string from the secret:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapi
spec:
  replicas: 4
  selector:
    matchLabels:
      app: myapi
  template:
    metadata:
      labels:
        app: myapi
    spec:
      containers:
        - name: myapi
          env:
            - name: ConnectionStrings__DefaultConnectionString
              valueFrom:
                secretKeyRef:
                  name: sqlsecrets
                  key: constr
          image: <ACR_NAME>.azurecr.io/adc-api-sql:1.0
          resources:
            limits:
              memory: '128Mi'
              cpu: '500m'
          ports:
            - containerPort: 5000
```

Update your Contact API's deployment using the `kubectl apply` command:

```shell
kubectl apply -f ./api.yaml
```

Open a browser navigate to your front-end and check if everything is still working.

[◀ Previous challenge](./challenge-2.md) | [🔼 Day 7](../README.md) | [Next challenge ▶](./challenge-4.md)
