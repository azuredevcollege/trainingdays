# Basic Kubernetes Concepts

## Prerequisites

In order to be able to store the custom Docker images you will be creating throughout this workshop, we need a container registry. Azure provides its own service for that, the Azure Container Registry. Let's create one via the Azure CLI:

```zsh
$ az group create --name adc-acr-rg --location germanywestcentral
$ az acr create --name adccontainerreg --resource-group adc-acr-rg --sku basic --admin-enabled

# now let's attach the container registry to the cluster 

$ az aks update --resource-group adc-aks-rg --name adc-cluster --attach-acr adccontainerreg
```

## Build a custom image

```zsh
$ docker build -t test:1.0 .
$ docker run -p 8080:80 test:1.0
```

Open your browser and navigate to `http://localhost:8080`. You should see a page with a welcome message.

Now let's push the image to our registry. To be able to interact with our registry, we first need to login.

```zsh
$ ACRPWD=$(az acr credential show -n adccontainerreg --query "passwords[0].value" -o tsv)
$ docker login adccontainerreg.azurecr.io -u adccontainerreg -p $ACRPWD
```

> In this sample, we used the `admin` account of our registry to login - basically with username/password. In secure/production environments, you should not enable the `admin` account on the registry and login via Azure Active Directory: `az acr login -n adccontainerreg`. The token that is issued will be valid for 3 hours.

We are now ready to push the image to our container registry.

```zsh
$ docker tag test:1.0 adccontainerreg.azurecr.io/test:1.0
$ docker push adccontainerreg.azurecr.io/test:1.0
````

You can also build directly within the Azure Container Registry service, in case you don't have Docker on your machine. Let's have try...

```zsh
$ az acr build -r adccontainerreg -t adccontainerreg.azurecr.io/test:2.0 .
```

The command will send the current build context to Azure, kick-off a docker build and add the image to your registry.

## Run your custom image

Now that we have an image in our container registry, let's create a pod. This time, we will be using a YAML manifest.

```yaml
# Content of file myfirstpod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: myfirstpod
spec:
  containers:
  - image: adccontainerreg.azurecr.io/test:2.0
    name: myfirstpod
    resources: {}
    ports:
        - containerPort: 80
  restartPolicy: Never
```

Create a file called `myfirstpod.yaml` with the content above and apply it to your cluster.

```zsh
$ kubectl apply -f myfirstpod.yaml
```

Check that everything works as expected.

```zsh
$ kubectl get pods -w
NAME         READY   STATUS              RESTARTS   AGE
myfirstpod   0/1     ContainerCreating   0          6s
...
...
[after a few seconds]
myfirstpod   1/1     Running             0          17s
```

Also, "describe" the pod to see some more details like status, the node it's running on, events etc.

```zsh
$ kubectl describe myfirstpod
Name:         myfirstpod
Namespace:    default
Priority:     0
Node:         aks-nodepool1-11985439-vmss000001/10.240.0.5
Start Time:   Thu, 08 Oct 2020 14:03:55 +0200
Labels:       <none>
Annotations:  Status:  Running
IP:           10.244.2.5
IPs:
  IP:  10.244.2.5
Containers:
  myfirstpod:
    Container ID:   docker://2dc2e9ef913a6985fe355bd871666bd6eec859eba544c051eb3b5db5d7eeb1ab
    Image:          adccontainerreg.azurecr.io/test:2.0
    Image ID:       docker-pullable://adccontainerreg.azurecr.io/test@sha256:0e6b51d93fd3769bda02b5865491092a595194ea04f5b8bd8f6209f101bde724
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 08 Oct 2020 14:03:56 +0200
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-9lb48 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-9lb48:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-9lb48
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age   From                                        Message
  ----    ------     ----  ----                                        -------
  Normal  Scheduled  13s   default-scheduler                           Successfully assigned default/myfirstpod to aks-nodepool1-11985439-vmss000001
  Normal  Pulled     12s   kubelet, aks-nodepool1-11985439-vmss000001  Container image "adccontainerreg.azurecr.io/test:2.0" already present on machine
  Normal  Created    12s   kubelet, aks-nodepool1-11985439-vmss000001  Created container myfirstpod
  Normal  Started    12s   kubelet, aks-nodepool1-11985439-vmss000001  Started container myfirstpod
```

So, the pod is running, but how do we access it?! Let's have a look at one option, that you typically would use in _test/debug_ scenarios. 

With `kubectl` you can "port-forward" a local port to a port on a pod. This is how it works in our case:

```zsh
$ kubectl port-forward myfirstpod 8080:80
```

Our pod is listening on port `80` and we forward our local port `8080` to that one. You can check the result by navigating - once again - to `http://localhost:8080`.

To proof that the requests arrive at the pod, check the logs:

```zsh
$ kubectl logs myfirstpod -f=true
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
127.0.0.1 - - [08/Oct/2020:12:09:04 +0000] "GET / HTTP/1.1" 200 171 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 Edg/85.0.564.70" "-"
127.0.0.1 - - [08/Oct/2020:12:09:04 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 Edg/85.0.564.70" "-"
127.0.0.1 - - [08/Oct/2020:12:09:04 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 Edg/85.0.564.70" "-"
127.0.0.1 - - [08/Oct/2020:12:09:04 +0000] "GET / HTTP/1.1" 304 0 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36 Edg/85.0.564.70" "-"
```

## Running multiple instances of our workload

Describe deployments

Still - no way to access our pods. It even got worse, because we now have mutliple pods running. We would need to find out all IP adresses of our pods to being able to send requests to them.

## Services

Describe service types

Add service in front of our pods

Internal access --> use busybox to wget index.html (ClusterIp + NodePort)

LoadBalancer type

## Ingress

Add an ingress controller in front of service



