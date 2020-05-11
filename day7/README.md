Add stroage account for terrastate

```shell
az group create --name adc-tfstate-rg --location westeurope

az storage account create -n tfstateadadc -g adc-tfstate-rg --sku Standard_LRS

az storage container create -n tfstate --account-name tfstateadadc --account-key `az storage account keys list -n tfstateadadc -g adc-tfstate-rg --query "[0].value" -otsv`
```

Kubernetes


k create ns dev

Ingress:

k create ns ingress

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install clstr-ingress stable/nginx-ingress --set rbac.create=true,controller.service.externalTrafficPolicy=Local --namespace ingress

Secret / Docker Reg

Dashboard

https://github.com/vmware-tanzu/octant/releases

Certmanager

kubectl create namespace cert-manager

helm repo add jetstack https://charts.jetstack.io

helm install cert-manager \
  --namespace cert-manager \
  --version v0.15.0 \
  jetstack/cert-manager \
   --set installCRDs=true \
   --set ingressShim.defaultIssuerName=letsencrypt-prod \
   --set ingressShim.defaultIssuerKind=ClusterIssuer \
   --set ingressShim.defaultIssuerGroup=cert-manager.io


apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    # The ACME server URL
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: chritian.dennig@microsoft.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-staging
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class:  nginx

---


apiVersion: cert-manager.io/v1alpha2
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # The ACME server URL
    server: https://acme-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: christian.dennig@microsoft.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-prod
    # Enable the HTTP-01 challenge provider
    solvers:
    - http01:
        ingress:
          class: nginx


--- 


apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ing-contacts
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-headers: "Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization,Accept-Language"
    nginx.ingress.kubernetes.io/cors-max-age: "600"
    nginx.ingress.kubernetes.io/proxy-body-size: "12m"
    nginx.ingress.kubernetes.io/rewrite-target: "/contacts/$2"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prod
spec:
  tls:
    - hosts:
        - 52-232-4-29.nip.io
      secretName: tls-secret
  rules:
  - host: 52-232-4-29.nip.io
    http:
      paths:
      - path: /api/contacts(/|$)(.*)
        backend:
          serviceName: contacts
          servicePort: 8080