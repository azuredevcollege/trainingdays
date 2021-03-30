# Image Pull Secret

In case you could not connect your Azure Container Registry to your AKS cluster, you can also use an image pull secret to give your cluster the permission to pull images from your private registry. Therefor, follow the steps below.

## Create a Kubernetes Secret

```zsh
ACR_PWD=(az acr credential show -n <ACR_NAME> --query passwords[0].value -o tsv)

kubectl create secret docker-registry regcred --docker-server=<ACR_NAME>.azurecr.io --docker-username=<ACR_NAME> --docker-password=$ACR_PWD --docker-email=<YOUR_EMAIL_ADDRESS>
```

## Use the Secret to pull images

In order to use the image pull secret during deployments, add the following section to your YAML manifest(s):

```yaml
imagePullSecrets:
- name: regcred
```

E.g. for a pod manifest:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: myfirstpod
spec:
  containers:
    - image: <ACR_NAME>.azurecr.io/test:2.0
      name: myfirstpod
      resources: {}
      ports:
        - containerPort: 80
  restartPolicy: Never
  imagePullSecrets:
  - name: regcred
```

Or for a deployment manifest:

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
              value: Server=tcp:<IP_OF_THE_SQL_POD>,1433;Initial Catalog=scmcontactsdb;Persist Security Info=False;User ID=sa;Password=Ch@ngeMe!23;MultipleActiveResultSets=False;Encrypt=False;TrustServerCertificate=True;Connection Timeout=30;
          image: <ACR_NAME>.azurecr.io/adc-api-sql:1.0
          resources:
            limits:
              memory: '128Mi'
              cpu: '500m'
          ports:
            - containerPort: 5000
      imagePullSecrets:
      - name: regcred
```
