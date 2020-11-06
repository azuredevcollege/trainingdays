# Configuration with Kubernetes Secrets and ConfigMaps

## Why do we need Secrets and ConfigMaps

It is actually obvious that certain settings of an application or service should not be hard coded in the source code of the application. Instead applications load these settings from a configuration file at runtime to avoid a new build of the application or service. By configuration files an application can be integrated configurably into other environments. Configuration files are however not the only possibility to configure applications. Environment variables are even more frequently used to configure an application or service. 
Your containerized applications need some certain data or credentials to run properly. In challenge 2 you have seen that running an SQL Server in a container you had to set a password, which was hard coded into the deployment file.

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
This is definitely not a good approach. With this approach it is not possible to use the same definition in another hosting environment without setting a new password (Unless you always use the same password, which of course is a no go).
Data such as a password are sensitive data and should be treated with special care. Sensitive data should be stored in a Secret Store to which only a certain group of users has access. With a Secret Store, developers do not have to store sensitive data in source code. The definition of a Kubernet deployment is definitely part of the source code.

In challenge 2 we created a deployment for the Contacts API. The API loads the connection string to the hosted SQL Server from an environment variable __ConnectionStrings__DefaultConnectionString__ . The connection string's value is hard coded, too.

```yaml
containers:
- name: myapi
    env:
    - name: ConnectionStrings__DefaultConnectionString
        value: Server=tcp:<IP_OF_THE_SQL_POD>,1433;Initial Catalog=scmcontactsdb;Persist Security Info=False;User ID=sa;Password=Ch@ngeMe!23;MultipleActiveResultSets=False;Encrypt=False;TrustServerCertificate=True;Connection Timeout=30;
    image: <ACR_NAME>.azurecr.io/adc-api-sql:1.0
```

Currently we have the Contacts API, the SQL Server and the front-end running in the cluster. Looking back at how the front-end was deployed, some of you may have wondered if this is the right way to update the configuration in source code and build a new container. The answer is of course no. The configuration for the front-end which is simply a JavaScript file must be somehow configured at deployment time not at the build time of the container. We need to be able to place the following file content into the container at deployment time.

```js
var uisettings = {
  endpoint: 'http://<YOUR_NIP_DOMAIN>/api/contacts/',
  enableStats: false,
  aiKey: '',
}
```

With Secrets and ConfigMapa, Kubernetes provides two objects that help us to configure applications or services at deployment time. In the next sections we will get to know these objects better.

## ConfigMaps

A ConfigMap is a Kuberenetes API object used to store non confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables or as configuration files in volume mounts. A ConfigMap allows you to decouple environment specific settings from your deployments and pod definitions or containers.

You can use `kubectl create configmap` command to create ConfigMaps from directories, files and literal values.

### Create a ConfigMap from iteral values

Now, let us first create a ConfigMap from literal values and let us look at how the ConfigMap object is built up.
Open a shell and run the `kubectl create configmap` command with the option --from-literal argument to define a literal value from the command line:

```zsh
$ kubectl create configmap myfirstmap --from-literal=myfirstkey=myfirstvalue --from-literal=mysecondkey=mysecondvalue --dry-run -o yaml
```

After the command has been executed, you will see the following output:

```zsh
apiVersion: v1
data:
  myfirstkey: myfirstvalue
  mysecondkey: mysecondvalue
kind: ConfigMap
metadata:
  creationTimestamp: null
  name: myfirstmap
```
In the data section of the object you can see that each key is mapped to a value. So far so good.
But how can these key-value pairs be accessed in a Pod or Deployment definition? Let's first see how to use the key-value pairs in environment variables. 

First, create the ConfigMap with name `myfirstmap`:

``` zsh
$ kubectl create configmap myfirstmap --from-literal=myfirstkey=myfirstvalue --from-literal=mysecondkey=mysecondvalue
```

If you want, you can use kubectl describe configmap to see how the ConfigMap is created:

```zsh
$ kubectl describe configmap myfirstmap
```

Now create a file fith name `myfirstconfigmapdemo.yaml`and add the following content:

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
    command: ["sleep", "3600"]
    env:
      - name: MYFIRSTVALUE
        valueFrom:
            configMapRef:
              name: myfirstmap
              key: myfirstvalue
      - name: MYSECONDVALUE
        valueFrom:
            configMapRef:
              name: myfirstmap
              key: mysecondvalue              
  restartPolicy: Never
```

In the definition you can see that we set the value for an environment variable by referencing the key of a ConfigMap.
Now deploy the definition:

```zsh
$ kubectl apply -f myfirstconfigmapdemo.yaml
```

To check if everything is setup correctly we can use the `kubectl exec` command to print all environment variables of the pod.

```zsh
kubectl exec myfirstconfigmapdemo -- /bin/sh -c printenv
...
MYFIRSTVALUE=myfirstvalue
MYSECONDVALUE=mysecondvalue
...
```
We have seen how you can reference values in a ConfigMap and use them as environment variable.
Before we continue with the next exercise and see how we can add ConfigMap's key and value pairs as files in a read-only volume, remove the deployed pod from your cluster.

```zsh
$ kubectl delete pod myfirstconfigmapdemo
```

Kubernetes supports many types of volumes. A Pod can use any number of volume types simultaneously. At its core, a volume is just a directory which is accessible to the container in a pod. How that directory comes to be a medium is determined by the particular volume type. At the end the volume must be mounted in the container to access it.
A ConfigMap provides a way to inject configuration data into pods. The data stored in a ConfigMap can be referenced in a volume of type configMap and then consumed by containerized applications running in a pod.

Let us see it in action. First create a new file and name it `volumedemo.yaml` and add the following content:

```Yaml
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
    command: ["sleep", "3600"]
    volumeMounts:
    # mount the config volume to path /config
    - name: config
      mountPath: "/config"
      readOnly: true
  volumes:
  # set volumes at the Pod level, then mount them into containers inside the pod
    - name: config
      configMap:
        # specify the name of the ConfigMap to use
        name: myfirstmap
        # an array of keys from the ConfigMap to create as file
        items:
        - key: "myfirstkey"
          path: "myfirstkey"
        - key: "mysecondkey"
          path: "mysecondkey"

```
Use `kubectl apply` command to create the Pod in your cluster:

```zsh
$ kubectl apply ./volumedemo.yaml
```

Next we can connect to the container by running the `kubectl exec` command with argument `-it` and open a shell inside the container:

```zsh
$ kubectl exec -it volumedemo -- /bin/sh
```

Now in the shell check the directory `/config`:

```Shell
>cd /config
config>ls 
myfirstkey   mysecondkey
more myfirstkey
myfirstvalue
```

All ConfigMap keys, specified in the items array of the pod definition, are created as files in the mounted volume and acessible to the container.

### Create a ConfigMap from file

In the previous exercise we have seen how key-value pairs are added to a ConfigMap using `--from-literal`. A ConfigMap's key-value pairs can be created from files, too. In this exercise we learn how to create ConfigMap key-value pairs from files and how to mount a volume to make these files accessibly to the container inside a pod.

First we need a file that contains the settings for a container. Create a file `demosettings.json` and add the following content:

```json
{
    "key1" : "value1",
    "key2" : "value2"
}
```

We can use the `kubectl create configmap` command with argument `--from-file` to create a key-value pair from a file.
Let us first try a dry-run to see how the ConfigMap object looks like:

```zsh
$ kubectl create configmap myfilemap --from-file=demosettings=./demosettings.json --dry-run -o yaml

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

The ConfigMap contains a key-value pair with key `demosettings` with the json file's content as value. Since the name of the key was specified with `demosettings` in `--from-file` it is the expected result. But it is also possible to leave out the name of the key. The name of the key will then be the name of the file.

```zsh
$ kubectl create configmap myfilemap --from-file=./demosettings.json --dry-run -o yaml

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

```zsh
$ kubectl create configmap myfilemap --from-file=demosettings=./demosettings.json
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
    command: ["sleep", "3600"]
    volumeMounts:
    # mount the config volume to path /config
    - name: config
      mountPath: "/config"
      readOnly: true
  volumes:
  # set volumes at the Pod level, then mount them into containers inside the pod
    - name: config
      configMap:
        # specify the name of the ConfigMap to use
        name: myfilemap
        # an array of keys from the ConfigMap to create as file
        items:
        - key: "demosettings"
          path: "demosettings.json"

```
This pod definition mounts the volume `config` to the path `/config` into the container. The volume is of type `configMap` and references the ConfigMap `myfilemap`. The content or value of the key `demosettings` is stored in a file named `demosettings.json` which is accessibly to the container under `/config/demosettings.json`.

Let us see it in action. Use the `kubectl apply` command to create the pod:

```zsh
$ kubectl apply -f ./volumefiledemo.yaml
```
After the pod is up and running we can use the `kubectl exec` command with argument `-it` to connect to the container inside the pod and open a shell:

```zsh
$ kubectl exec -it volumefiledemo -- /bin/sh
```

Now we can check if the file and its content is available:

```shell
/ cd config
/config ls
demosettings.json
/config more ./demosettings.json
{
    "key1" : "value1",
    "key2" : "value2"
}
```

## Secrets

What for?
Not really secure --> use KeyVault

### Literal Values

show creation and how to use in case of contacts api (env: ConnectionStrings\_\_DefaultConnectionString)
