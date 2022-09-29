# Challenge 6: Networking - Load balancing your WWW Server Farm

## Here is what you will learn 🎯

- How to load balance http traffic to 2 webserver VMs
- Create an external load balancer using the Azure portal
- Learn to know the requirements for an Azure external load balancer and how to configure it.

Our final architecture should look like this:
![Final architecture](./images/finalArchitecture.png)  

At first you will deploy the _start environment_ and then you will add the external _load balancer_.

## Table of Contents

1. [Deploy the Starting Point](#deploy-the-starting-point)
2. [Deploy the Load Balancer](#deploy-the-load-balancer)
3. [Test server outage (optional)](#test-server-outage-optional)
4. [Cleanup](#cleanup)

## Deploy the Starting Point

In this directory there is an ARM-template which includes 2 web server VMs and its requirements (networking, disks,...):  

!['Starting Point' Architecture](./images/startingpoint01.png)  

Deploy this scenario into your subscription by **clicking** on the <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazuredevcollege%2Ftrainingdays%2Fmaster%2Fday1%2Fchallenge-06%2Fchallengestart%2Fchallengestart.json"><img src="./challengestart/deploytoazure.png"/></a>
button.  

| Name | Value |
|---|---|
| _Resource group_  |  **(new)** rg-lbwww |
| _Location_  |  West Europe |
| _Admin user_  |  demouser |
| _Admin password_  |  %some complex value%|
| _Vm Size_  |  Standard_B2s  or try e.g. Standard_F2s_v2 |
| _Disk Sku_  |  StandardSSD_LRS |  
  
The result should look similar to this:

![Deployment result](./images/startingpoint02.png)  

## Deploy the Load Balancer

Now let's add an external Azure load balancer in front of the two parallel web server machines.  

```
[Azure Portal] 
-> '+' Add 
-> Search the marketplace for 'Load balancer'
```  

| Name | Value |
|---|---|
| _Resource group_  |  rg-lbwww |
| _Name_  | lb-wwwfarm |
| _Region_  |  West Europe |
| _Type_  |  Public |
| _SKU_  |  Basic |
| _Public IP address_  |  %Use existing% |
| _Choose public IP address_  |  pip-wwwfarm |  
  
:::tip
📝To get your load balancer working you need to configure the following:

- A _backend pool_ that contains the endpoints i.e. the VMs to which the traffic will be routed.

  ![backend pool](./images/lbconfig01.png)
- A _health probe_ for TCP port 80 (http) to check if the endpoints are 'responsive' to web requests

  ![health probe](./images/lbconfig02.png)
- A _lb rule_ to forward incoming traffic (TCP port 80) on lb's frontend IP address to backend pool (TCP port 80)

  ![lb rule](./images/lbconfig03.png)
:::

To check if your lb is working do a HTTP request to the endpoint `http://%PIP of your lb%`. Depending which endpoint serves your request the result should look like:

  ![lbresult1](./images/lbresult1.png)

  ![lbresult2](./images/lbresult2.png)

## Test server outage (optional)

1. Stop one VM and verify if the webpage is still served.  
2. Restart the VM and check if the lb notices it and re-balances load.

## Cleanup

Delete the resource group `rg-lbwww`.

[◀ Previous challenge](../challenge-05/README.md) | [🔼 Day 1](../README.md) | [Next challenge ▶](../challenge-07/README.md)