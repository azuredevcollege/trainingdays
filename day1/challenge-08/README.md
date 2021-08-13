# Challenge 8: Networking and VPN - Enabling Hybrid Networking with a Site-2-Site (Onprem to Azure) VPN Connection

## Here is what you will learn 🎯

What it takes to implement a VPN tunnel between your onprem firewall <---VPN S2S---> Azure. Our final architecture will look like this:  
![Hybrid Network with Azure](./images/goal.png)

An Azure S2S VPN requires:
| onprem | Azure |
| ------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| A supported device Azure can talk to. | <ul><li>VPN Gateway in its own subnet.</li><li>VPN GWay requires a dynamic Public IP</li><li>Settings how the onprem VPN / FWall is to be contacted (aka LocalNetworkGateway)</li><li>Connection Object with e.g. shared key</li></ul> |

## Table of Contents

- [Challenge 8: Networking and VPN - Enabling Hybrid Networking with a Site-2-Site (Onprem to Azure) VPN Connection](#challenge-8-networking-and-vpn---enabling-hybrid-networking-with-a-site-2-site-onprem-to-azure-vpn-connection)
  - [Here is what you will learn 🎯](#here-is-what-you-will-learn-)
  - [Table of Contents](#table-of-contents)
  - [Starting Point](#starting-point)
  - [Create a VPN Gateway and a Public IP using the Azure portal](#create-a-vpn-gateway-and-a-public-ip-using-the-azure-portal)
  - [Create a Local Network Gateway in Azure](#create-a-local-network-gateway-in-azure)
  - [Create a connection object with shared key in Azure](#create-a-connection-object-with-shared-key-in-azure)
  - [Configure your onpremise VPN counterpart](#configure-your-onpremise-vpn-counterpart)
  - [Apply a more secure cipher for the VPN tunnel (optional)](#apply-a-more-secure-cipher-for-the-vpn-tunnel-optional)
  - [Cleanup](#cleanup)

## Starting Point

Your instructor has setup for you the onprem part - _ask him for the details_:

![Onpremise](./images/onpremise.png)

**Click** on the <a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazuredevcollege%2Ftrainingdays%2Fmaster%2Fday1%2Fchallenge-08%2Fchallengestart%2Fchallengestart.json"><img src="./challengestart/deploytoazure.png"/></a>
button to get the Azure resources to start with:  
![azure vpn starting point](./images/vpnLabAzureStart.png)

| Name             | Value                                    |
| ---------------- | ---------------------------------------- |
| _Resource group_ | **(new)** rg-vpn                         |
| _Location_       | North Europe                             |
| _Admin user_     | demouser                                 |
| _Admin password_ | %some complex value%                     |
| _Vm Size_        | Standard_B2s or try e.g. Standard_F2s_v2 |
| _Disk Sku_       | StandardSSD_LRS                          |

## Create a VPN Gateway and a Public IP using the Azure portal

`[Azure Portal] -> '+ Create a resource' -> type "Virtual network gateway" -> Create`

Use the following parameter values:

| Parameter Name                 | Values               |
| ------------------------------ | -------------------- |
| _Name_                         | myAzVPNGWay          |
| _Region_                       | North Europe         |
| _Gateway type_                 | VPN                  |
| _VPN Type_                     | Route based          |
| _Gateway type_                 | VPN                  |
| _SKU_                          | VpnGw1               |
| _Virtual Network_              | vnet-vpn             |
| _Gateway subnet address range_ | e.g. 10.1.254.192/26 |
| _Public IP address_            | **Create new**       |
| _Public IP address name_       | myAzVPNGWay-IP       |
| _Enable active-active mode_    | Disabled             |
| _Configure BGP_                | Disabled             |

The GW setup will take approx 30 mins. to create. So come back later (e.g. in the meantime you can do the next lab :-))

When your GW has been assigned a _public IP address_ then you know it is online.

![VPN GW with public IP](./images/vpnGWPIP.png)

## Create a Local Network Gateway in Azure

The purpose of this task is to tell Azure how to contact the onpremise firewall:

`[Azure Portal] -> '+ Add' -> type 'Local network gateway' -> Create`

| Parameter Name   | Values                                          |
| ---------------- | ----------------------------------------------- |
| _Name_           | l-gw-ipfire                                     |
| _IP address_     | %external IP of your Firewall - ask instructor% |
| _Address Space_  | 192.168.0.0/24                                  |
| _Resource Group_ | rg-vpn                                          |
| _Location_       | North Europe                                    |

## Create a connection object with shared key in Azure

`[Azure Portal] -> Resource Groups -> rg-vpn -> myAzVPNGWay -> Connections`

| Parameter Name            | Values               |
| ------------------------- | -------------------- |
| _Name_                    | azure-to-onprem      |
| _Connection Type_         | Site-to-Site (IPSec) |
| _Virtual Network Gateway_ | myAzVPNGWay          |
| _Local Network Gateway_   | l-gw-ipfire          |
| _Shared Key_              | %your choice here%   |
| _IKE Protocol_            | IKEv2                |
| _Resource Group_          | rg-vpn               |
| _Location_                | North Europe         |

## Configure your onpremise VPN counterpart

We now need to configure the other end of the vpn tunnel: the onpremise firewall in our case a linux FW called _IPFire_.

1. For this use the remote desktop client to RDP into your onpremise environment (_ask your instructor for connection details_):

`Internet -- 1st RDP -> onprem Lab (HyperV Host) -- 2nd RDP -> cmW2k19 (192.168.0.11) --https -> IPFire (192.168.0.100)`

![Connection Flow](./images/connectionFlow.png)

| Parameter Name                                                       | Values                                                                                                                             |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| _connect to 1st RDP_                                                 | <ul><li><b>IP</b>: %ask instructor%</li><li><b>username</b>: demouser</li><li><b>password</b>: %ask instructor%</li></ul>          |
| _within this session connect to 2nd RDP_                             | <ul><li><b>IP</b>: 192.168.0.11</li><li><b>username</b>: administrator</li><li><b>password</b>: %ask instructor%</li></ul>         |
| _open browser and do https_ ( ignore certificate warning -> proceed) | <ul><li><b>URI</b>: <https://192.168.0.100:444></li><li><b>username</b>: admin</li><li><b>password</b>: %ask instructor%</li></ul> |

2. Add the VPN details and save

`IPFire -> Services -> IPSec -> 'Connection Status and -Control' -> Add`

![IPFire: Add a connection](./images/vpn0.png)

```
"Net-to-Net Virtual Private Network" -> Add
```

![IPFire: add Net-to-Net connection](./images/vpn1.png)

| Parameter Name         | Values                                                                                 |
| ---------------------- | -------------------------------------------------------------------------------------- |
| _Name_                 | azure                                                                                  |
| _Local subnet_         | 192.168.0.0/255.255.255.0                                                              |
| _Remote Host/IP_       | %myAzVPNGWay IP Address% (Azure Portal -> VPN Gateway -> Public IP address)            |
| _Remote subnet_        | %Address Range of the virtual network in azure% (in our case 10.1.0.0/255.255.0.0)     |
| _Use a pre-shared key_ | %Shared Key you used above% (Azure Portal -> VPN Gateway -> Connections -> Shared Key) |

![IPFire: connection settings](./images/vpn2.png)

3. Modify the algorithms used for the connection. Click on the pencil symbol and choose 'Advanced':

![IPFire: Advanced cipher settings](./images/vpn3.png)

3.1 You _must_ select the following algorithms/suites for the connection:

![IPFire: connection settings](./images/vpn4.png)

3.2 Select `Always on`, then save

3.3 Tick checkbox to enable connection. The connection status should go to green:

![IPFire: connection settings](./images/vpn5.png)

4. Now let's ping your Azure VM (e.g. vmazure) under its private ip (probably: 10.1.0.4) from onpremise:

![Successful Ping](./images/successfulPing.png)
Do you receive a response?

## Apply a more secure cipher for the VPN tunnel (optional)

The following ARM Template ([VPNMoreSecureConnPolicy.json](./scripts/VPNMoreSecureConnPolicy.json)) defines a more secure cipher / algorithm to use for the VPN tunnel:  
| Parameter Name | Values |
| ----------------- | --------- |
| _ipsecEncryption_ | AES256 |
| _ipsecIntegrity_ | SHA256 |
| _ikeEncryption_ | AES256 |
| _ikeIntegrity_ | SHA384 |
| _dhGroup_ | DHGroup14 |
| _pfsGroup_ | PFS2048 |

To deploy it, **click** the
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fazuredevcollege%2Ftrainingdays%2Fmaster%2Fday1%2Fchallenges%2FChallenge8%2FVPNMoreSecureConnPolicy.json"><img src="./challengestart/deploytoazure.png"/></a> button and select correct parameters to apply new ciphers to your current connection.

However, you also need to apply this to the onprem firewall:

![VPN more secure cipher](./images/vpn6-moresecure.png)

## Cleanup

Delete the resource group `rg-vpn`

[◀ Previous challenge](../challenge-07/README.md) | [🔼 Day 1](../README.md) | [Next challenge ▶](../challenge-09/README.md)
