(window.webpackJsonp=window.webpackJsonp||[]).push([[38],{699:function(e,t,s){e.exports=s.p+"assets/img/rg-created.6f8a203d.png"},700:function(e,t,s){e.exports=s.p+"assets/img/cluster-rg.d29bea96.png"},701:function(e,t,s){e.exports=s.p+"assets/img/auto-rg.db7f5b11.png"},702:function(e,t,s){e.exports=s.p+"assets/img/dashboard-login.fe616b47.png"},703:function(e,t,s){e.exports=s.p+"assets/img/all-namespaces-dashboard.1e83fb32.png"},803:function(e,t,s){"use strict";s.r(t);var a=s(10),r=Object(a.a)({},(function(){var e=this,t=e._self._c;return t("ContentSlotsDistributor",{attrs:{"slot-key":e.$parent.slotKey}},[t("h1",{attrs:{id:"challenge-1-create-your-first-kubernetes-cluster"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#challenge-1-create-your-first-kubernetes-cluster"}},[e._v("#")]),e._v(" Challenge 1: Create your first Kubernetes Cluster")]),e._v(" "),t("h2",{attrs:{id:"here-is-what-you-will-learn-🎯"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#here-is-what-you-will-learn-🎯"}},[e._v("#")]),e._v(" Here is what you will learn 🎯")]),e._v(" "),t("p",[e._v("In this challenge we will create a Kubernetes cluster. To achieve this so we will:")]),e._v(" "),t("ul",[t("li",[e._v("Use the Azure CLI")]),e._v(" "),t("li",[e._v("Configure your local access credentials to control your cluster using kubectl")]),e._v(" "),t("li",[e._v("Take some first steps")]),e._v(" "),t("li",[e._v("Run our first pod")])]),e._v(" "),t("h2",{attrs:{id:"table-of-contents"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#table-of-contents"}},[e._v("#")]),e._v(" Table Of Contents")]),e._v(" "),t("ol",[t("li",[t("a",{attrs:{href:"#create-the-cluster"}},[e._v("Create the cluster")])]),e._v(" "),t("li",[t("a",{attrs:{href:"#establish-access-to-the-cluster"}},[e._v("Establish Access to the Cluster")])]),e._v(" "),t("li",[t("a",{attrs:{href:"#access-the-dashboard"}},[e._v("Access the Dashboard")])]),e._v(" "),t("li",[t("a",{attrs:{href:"#run-your-first-pod"}},[e._v("Run your First Pod")])])]),e._v(" "),t("h2",{attrs:{id:"create-the-cluster"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#create-the-cluster"}},[e._v("#")]),e._v(" Create the cluster")]),e._v(" "),t("p",[e._v("To have a clean overview of what is being provisioned under the hood, we create a new resource\ngroup and and create our Kubernetes cluster within it:")]),e._v(" "),t("div",{staticClass:"language-shell extra-class"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[e._v("az group create "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("--name")]),e._v(" adc-aks-rg "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("--location")]),e._v(" westeurope\naz aks create --resource-group adc-aks-rg "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("--name")]),e._v(" adc-cluster --enable-managed-identity --generate-ssh-keys --kubernetes-version "),t("span",{pre:!0,attrs:{class:"token number"}},[e._v("1.22")]),e._v(".6\n")])])]),t("p",[e._v("Let's inspect the created resources:")]),e._v(" "),t("p",[t("img",{attrs:{src:s(699),alt:"Created resource groups"}})]),e._v(" "),t("p",[e._v("The "),t("code",[e._v("az aks create")]),e._v(" command created a second resource group named\n"),t("code",[e._v("MC_adc-aks-rg_adc-cluster_westeurope")]),e._v(" containing all resources provisioned for our AKS\ncluster:")]),e._v(" "),t("p",[t("img",{attrs:{src:s(700),alt:"Resource group with AKS resource"}})]),e._v(" "),t("p",[e._v("The resource group we explicitly created only holds the AKS resource "),t("em",[e._v("per se")]),e._v(":")]),e._v(" "),t("p",[t("img",{attrs:{src:s(701),alt:"Automatically created resource group"}})]),e._v(" "),t("p",[e._v("All other resource for the cluster are created in its own resource group.")]),e._v(" "),t("div",{staticClass:"custom-block tip"},[t("p",{staticClass:"custom-block-title"},[e._v("TIP")]),e._v(" "),t("p",[e._v("📝 This resource group and all its resources will be deleted when the cluster is destroyed.")])]),e._v(" "),t("h2",{attrs:{id:"establish-access-to-the-cluster"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#establish-access-to-the-cluster"}},[e._v("#")]),e._v(" Establish Access to the Cluster")]),e._v(" "),t("p",[e._v("Now it's time to access our cluster. To authenticate us against the cluster Kubernetes uses "),t("em",[e._v("client\ncertificates")]),e._v(" and "),t("em",[e._v("access tokens")]),e._v(".")]),e._v(" "),t("p",[e._v("To obtain these access credentials for our newly created cluster we\nuse the "),t("code",[e._v("az aks get-credentials")]),e._v(" command:")]),e._v(" "),t("div",{staticClass:"language-shell extra-class"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[e._v("$ az aks get-credentials --resource-group adc-aks-rg "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("--name")]),e._v(" adc-cluster\nMerged "),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"adc-cluster"')]),e._v(" as current context "),t("span",{pre:!0,attrs:{class:"token keyword"}},[e._v("in")]),e._v(" /home/waltken/.kube/config\n\n$ kubectl version "),t("span",{pre:!0,attrs:{class:"token comment"}},[e._v("# check client and server version of kubernetes")]),e._v("\nClient Version: version.Info"),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("{")]),e._v("Major:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"1"')]),e._v(", Minor:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"20"')]),e._v(", GitVersion:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"v1.20.2"')]),e._v(", GitCommit:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"faecb196815e248d3ecfb03c680a4507229c2a56"')]),e._v(", GitTreeState:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"clean"')]),e._v(", BuildDate:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"2021-01-14T18:56:46Z"')]),e._v(", GoVersion:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"go1.15.6"')]),e._v(", Compiler:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"gc"')]),e._v(", Platform:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"linux/amd64"')]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("}")]),e._v("\nServer Version: version.Info"),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("{")]),e._v("Major:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"1"')]),e._v(", Minor:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"19"')]),e._v(", GitVersion:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"v1.19.7"')]),e._v(", GitCommit:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"14f897abdc7b57f0850da68bd5959c9ee14ce2fe"')]),e._v(", GitTreeState:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"clean"')]),e._v(", BuildDate:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"2021-01-22T17:29:38Z"')]),e._v(", GoVersion:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"go1.15.5"')]),e._v(", Compiler:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"gc"')]),e._v(", Platform:"),t("span",{pre:!0,attrs:{class:"token string"}},[e._v('"linux/amd64"')]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("}")]),e._v("\n")])])]),t("p",[t("code",[e._v("kubectl version")]),e._v(" prints both the version of the locally running command line tool as well as the\nKubernetes version running on our cluster.")]),e._v(" "),t("div",{staticClass:"custom-block tip"},[t("p",{staticClass:"custom-block-title"},[e._v("TIP")]),e._v(" "),t("p",[e._v("📝 To inspect the access credentials and cluster\nconfiguration stored for us in our "),t("code",[e._v("~/.kube/config")]),e._v(" file run "),t("code",[e._v("kubectl config view")]),e._v(".")])]),e._v(" "),t("p",[e._v("We've setup access to our Kubernetes cluster. Now we can start exploring and working with our\ncluster.")]),e._v(" "),t("h2",{attrs:{id:"access-the-dashboard"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#access-the-dashboard"}},[e._v("#")]),e._v(" Access the Dashboard")]),e._v(" "),t("p",[e._v("AKS no longer comes with the kubernetes-dashboard installed by default. Lucky\nfor us there is a one-liner to quickly install the dashboard into our\ncluster:")]),e._v(" "),t("div",{staticClass:"language-shell extra-class"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[e._v("kubectl apply "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("-f")]),e._v(" https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml\n")])])]),t("p",[e._v("Now, accessing the dashboard requires us to create a "),t("code",[e._v("ServiceAccount")]),e._v(" with the\n"),t("em",[e._v("cluster-admin")]),e._v(" "),t("code",[e._v("ClusterRole")]),e._v(".")]),e._v(" "),t("p",[e._v("To create these "),t("code",[e._v("Resources")]),e._v(" within our Kubernetes cluster we will first declare the desired\nconfiguration for our "),t("code",[e._v("ServiceAccount")]),e._v(" in a YAML file and apply the desired configuration to our\ncluster using the "),t("code",[e._v("kubectl apply")]),e._v(" command:")]),e._v(" "),t("div",{staticClass:"language-yaml extra-class"},[t("pre",{pre:!0,attrs:{class:"language-yaml"}},[t("code",[t("span",{pre:!0,attrs:{class:"token comment"}},[e._v("# dashboard-admin.yaml")]),e._v("\n\n"),t("span",{pre:!0,attrs:{class:"token comment"}},[e._v("# Create a ServiceAccount that we can use to access the Dashboard")]),e._v("\n"),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("apiVersion")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" v1\n"),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("kind")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" ServiceAccount\n"),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("metadata")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v("\n  "),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("name")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" admin"),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("-")]),e._v("user "),t("span",{pre:!0,attrs:{class:"token comment"}},[e._v("# Create a ServiceAccount named admin-user")]),e._v("\n  "),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("namespace")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" kubernetes"),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("-")]),e._v("dashboard\n\n"),t("span",{pre:!0,attrs:{class:"token comment"}},[e._v("# This separates multiple resource definitions in a single file")]),e._v("\n"),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("---")]),e._v("\n"),t("span",{pre:!0,attrs:{class:"token comment"}},[e._v("# Bind the cluster-admin ClusterRole to the admin-user ServiceAccount")]),e._v("\n"),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("apiVersion")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" rbac.authorization.k8s.io/v1\n"),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("kind")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" ClusterRoleBinding\n"),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("metadata")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v("\n  "),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("name")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" admin"),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("-")]),e._v("user\n"),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("roleRef")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v("\n  "),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("apiGroup")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" rbac.authorization.k8s.io\n  "),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("kind")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" ClusterRole\n  "),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("name")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" cluster"),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("-")]),e._v("admin\n"),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("subjects")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v("\n  "),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("-")]),e._v(" "),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("kind")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" ServiceAccount\n    "),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("name")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" admin"),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("-")]),e._v("user\n    "),t("span",{pre:!0,attrs:{class:"token key atrule"}},[e._v("namespace")]),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v(":")]),e._v(" kubernetes"),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("-")]),e._v("dashboard\n")])])]),t("p",[e._v("Create a new "),t("code",[e._v("dashboard-admin.yaml")]),e._v(" file and paste the above content.")]),e._v(" "),t("div",{staticClass:"custom-block tip"},[t("p",{staticClass:"custom-block-title"},[e._v("TIP")]),e._v(" "),t("p",[e._v("📝 You will be creating lots of YAML files today - hooray! 😃 Create a folder called "),t("code",[e._v("yaml")]),e._v(" in the root directory of your repo and save all files you create within this directory. You can apply the manifests via kubectl from the folder.")])]),e._v(" "),t("p",[e._v("We can apply the configuration via:")]),e._v(" "),t("div",{staticClass:"language-shell extra-class"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[e._v("$ kubectl apply "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("-f")]),e._v(" dashboard-admin.yaml\nserviceaccount/admin-user created\nclusterrolebinding.rbac.authorization.k8s.io/admin-user created\n")])])]),t("p",[e._v("We need to discover the created users secret access token, to gain access to the dashboard:")]),e._v(" "),t("div",{staticClass:"language-shell extra-class"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[e._v("$ kubectl "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("-n")]),e._v(" kubernetes-dashboard get secret\nNAME                               TYPE                                  DATA   AGE\nadmin-user-token-22554             kubernetes.io/service-account-token   "),t("span",{pre:!0,attrs:{class:"token number"}},[e._v("3")]),e._v("      32s\ndefault-token-8fjcr                kubernetes.io/service-account-token   "),t("span",{pre:!0,attrs:{class:"token number"}},[e._v("3")]),e._v("      76s\nkubernetes-dashboard-certs         Opaque                                "),t("span",{pre:!0,attrs:{class:"token number"}},[e._v("0")]),e._v("      76s\nkubernetes-dashboard-csrf          Opaque                                "),t("span",{pre:!0,attrs:{class:"token number"}},[e._v("1")]),e._v("      76s\nkubernetes-dashboard-key-holder    Opaque                                "),t("span",{pre:!0,attrs:{class:"token number"}},[e._v("2")]),e._v("      75s\nkubernetes-dashboard-token-zmvj4   kubernetes.io/service-account-token   "),t("span",{pre:!0,attrs:{class:"token number"}},[e._v("3")]),e._v("      76s\n")])])]),t("p",[e._v("Find the secret that belongs to the "),t("code",[e._v("admin-user-token")]),e._v(" and use "),t("code",[e._v("kubectl describe")]),e._v(" to see the content of the secret:")]),e._v(" "),t("div",{staticClass:"language-shell extra-class"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[e._v("$ kubectl "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("-n")]),e._v(" kubernetes-dashboard describe secret admin-user-token-smw2j\nName:         admin-user-token-22554\nNamespace:    kubernetes-dashboard\nLabels:       "),t("span",{pre:!0,attrs:{class:"token operator"}},[e._v("<")]),e._v("none"),t("span",{pre:!0,attrs:{class:"token operator"}},[e._v(">")]),e._v("\nAnnotations:  kubernetes.io/service-account.name: admin-user\n              kubernetes.io/service-account.uid: 02a8e2e7-c25d-48a2-b8b8-f6ce99e77a5d\n\nType:  kubernetes.io/service-account-token\n\nData\n"),t("span",{pre:!0,attrs:{class:"token operator"}},[e._v("==")]),t("span",{pre:!0,attrs:{class:"token operator"}},[e._v("==")]),e._v("\nca.crt:     "),t("span",{pre:!0,attrs:{class:"token number"}},[e._v("1765")]),e._v(" bytes\nnamespace:  "),t("span",{pre:!0,attrs:{class:"token number"}},[e._v("20")]),e._v(" bytes\ntoken:      XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n")])])]),t("div",{staticClass:"custom-block warning"},[t("p",{staticClass:"custom-block-title"},[e._v("WARNING")]),e._v(" "),t("p",[e._v("⚠️ Watch out! You token will have a different random 5 character suffix.")])]),e._v(" "),t("p",[e._v("Copy the token to your clipboard for the next step.")]),e._v(" "),t("p",[e._v("Now we start the kubernetes proxy to access the remote API safely on our local machine:")]),e._v(" "),t("div",{staticClass:"language-shell extra-class"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[e._v("$ kubectl proxy\nStarting to serve on "),t("span",{pre:!0,attrs:{class:"token number"}},[e._v("127.0")]),e._v(".0.1:8001\n")])])]),t("p",[e._v("The process keeps running until you interrupt it using "),t("code",[e._v("Ctrl-C")]),e._v(". Let's keep it running for now.")]),e._v(" "),t("p",[t("a",{attrs:{href:"http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/",target:"_blank",rel:"noopener noreferrer"}},[e._v("Access the dashboard"),t("OutboundLink")],1),e._v("\nand login using the token you've acquired for the "),t("em",[e._v("admin-user")]),e._v(" "),t("code",[e._v("ServiceAccount")]),e._v(".")]),e._v(" "),t("div",{staticClass:"custom-block warning"},[t("p",{staticClass:"custom-block-title"},[e._v("WARNING")]),e._v(" "),t("p",[e._v("⚠️ Please note that the dashboard is proxied under a path containing the namespace and deployment path like this: "),t("a",{attrs:{href:"http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/",target:"_blank",rel:"noopener noreferrer"}},[e._v("http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/"),t("OutboundLink")],1)])]),e._v(" "),t("p",[t("img",{attrs:{src:s(702),alt:"Dashboard Login"}})]),e._v(" "),t("p",[e._v("Take your time to explore the dashboard. Make use of the "),t("code",[e._v("Namespace")]),e._v(" selector to navigate the\ndifferent namespaces.")]),e._v(" "),t("p",[t("img",{attrs:{src:s(703),alt:"Dashboard Overview"}})]),e._v(" "),t("div",{staticClass:"custom-block warning"},[t("p",{staticClass:"custom-block-title"},[e._v("WARNING")]),e._v(" "),t("p",[e._v("⚠️ "),t("strong",[e._v("Security Note:")]),e._v(' The dashboard component is considered a "security risk", because it is an additional way to access your cluster - and you have to take care of securing it.')]),e._v(" "),t("p",[e._v("Normally, you would not install the dashboard component in production clusters. There is an option for disabling the dashboard, even after installation: "),t("code",[e._v("az aks disable-addons -a kube-dashboard -n my_cluster_name -g my_cluster_resource_group")]),e._v(".")])]),e._v(" "),t("h2",{attrs:{id:"run-your-first-pod"}},[t("a",{staticClass:"header-anchor",attrs:{href:"#run-your-first-pod"}},[e._v("#")]),e._v(" Run your First Pod")]),e._v(" "),t("p",[e._v("Now we will run our "),t("em",[e._v("first pod")]),e._v(" on our kubernetes cluster. Let's keep the "),t("code",[e._v("kubectl proxy")]),e._v(" command running and execute this in new tab in your console.")]),e._v(" "),t("div",{staticClass:"language-shell extra-class"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[e._v("$ kubectl run "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("-i")]),e._v(" "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("-t")]),e._v(" pod1 "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("--image")]),t("span",{pre:!0,attrs:{class:"token operator"}},[e._v("=")]),e._v("busybox "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("--restart")]),t("span",{pre:!0,attrs:{class:"token operator"}},[e._v("=")]),e._v("Never "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("--rm")]),t("span",{pre:!0,attrs:{class:"token operator"}},[e._v("=")]),e._v("true\nIf you don't see a "),t("span",{pre:!0,attrs:{class:"token builtin class-name"}},[e._v("command")]),e._v(" prompt, try pressing enter.\n/ "),t("span",{pre:!0,attrs:{class:"token comment"}},[e._v("#")]),e._v("\n")])])]),t("p",[e._v("We've just started a "),t("code",[e._v("Pod")]),e._v(" named "),t("em",[e._v("pod1")]),e._v(" based on the "),t("em",[e._v("busybox")]),e._v(" image.")]),e._v(" "),t("p",[e._v("To understand the different flags we've added to the command take a look at the built in documentation to "),t("code",[e._v("kubectl run")]),e._v(".")]),e._v(" "),t("div",{staticClass:"language-shell extra-class"},[t("pre",{pre:!0,attrs:{class:"language-shell"}},[t("code",[e._v("$ kubectl run "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("--help")]),e._v("\nCreate and run a particular image "),t("span",{pre:!0,attrs:{class:"token keyword"}},[e._v("in")]),e._v(" a pod.\n\nExamples:\n  "),t("span",{pre:!0,attrs:{class:"token comment"}},[e._v("# Start a nginx pod.")]),e._v("\n  kubectl run nginx "),t("span",{pre:!0,attrs:{class:"token parameter variable"}},[e._v("--image")]),t("span",{pre:!0,attrs:{class:"token operator"}},[e._v("=")]),e._v("nginx\n\n"),t("span",{pre:!0,attrs:{class:"token punctuation"}},[e._v("..")]),e._v(".\n")])])]),t("blockquote",[t("p",[e._v("❔ "),t("strong",[e._v("Question")]),e._v(": What do the different flags ("),t("code",[e._v("-i")]),e._v(", "),t("code",[e._v("-t")]),e._v(", "),t("code",[e._v("--restart=Never")]),e._v(", "),t("code",[e._v("--rm=True")]),e._v(") used in the "),t("code",[e._v("kubectl run")]),e._v(" command do?")])]),e._v(" "),t("p",[t("RouterLink",{attrs:{to:"/day7/challenges/challenge-0.html"}},[e._v("◀ Previous challenge")]),e._v(" | "),t("RouterLink",{attrs:{to:"/day7/"}},[e._v("🔼 Day 7")]),e._v(" | "),t("RouterLink",{attrs:{to:"/day7/challenges/challenge-2.html"}},[e._v("Next challenge ▶")])],1)])}),[],!1,null,null,null);t.default=r.exports}}]);