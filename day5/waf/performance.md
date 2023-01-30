WIP

# Performance Efficiency overview

Performance efficiency is the **ability of your workload to scale to meet the demands placed on it by users in an efficient manner**. Before the cloud became popular, when it came to planning how a system would handle increases in load, many organizations intentionally provisioned oversized workloads to meet business requirements. This decision made sense in on-premises environments because it ensured capacity during peak usage. Capacity reflects resource availability (CPU and memory) and it was a major consideration for processes that would be in place for many years.

## Performance efficiency guidance

Just as you need to anticipate increases in load in on-premises environments, you need to expect increases in cloud environments to meet business requirements. One difference is that you may no longer need to make long-term predictions for expected changes to ensure you'll have enough capacity in the future. The following principles offer guidance on designining and improving high-performing Azure applications:

- Define a capacity model according to the business requirements
- Use PaaS offerings
- Choose the right resources and right-size
- Apply strategies in your design early

To assess your workload using the principles found in the [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/architecture/framework/), reference the [Microsoft Azure Well-Architected Review](https://learn.microsoft.com/en-us/assessments/?id=azure-architecture-review&mode=pre-assessment).

## Simple Contact Management

We took some minimal steps in terms of performance efficiency when building our applications. Nevertheless, it is not close to be production-ready. Since we did not expect high workloads and the app was just built for testing purposes, we paid little attention to scalability, networking, performance targets, etc. Due to this, we only got a score of 4/100 in the Well-Architected-Framework Review.

## Well-Architected-Framework Review

Tami: just added all questions and answers I gave here - for those which I found interesting and easy to answer, I added all possible alternatives :p we can check together whether they make sense.

### What design considerations have you made for performance efficiency in your workload?

- [ ] The workload is deployed across multiple regions.
- [x] **Regions were chosen based on location, proximity to users, and resource type availability.**
- [ ] Paired regions are used appropriately.
- [ ] You have ensured that both (all) regions in use have the same performance and scale SKUs that are currently leveraged in the primary region.
- [ ] Within a region the application architecture is designed to use Availability Zones.
- [ ] The application is implemented with strategies for resiliency and self-healing.
- [ ] Component proximity is considered for application performance reasons.
- [ ] The application can operate with reduced functionality or degraded performance in the case of an outage.
- [ ] You choose appropriate datastores for the workload during the application design.
- [ ] Your application is using a micro-service architecture.
- [ ] You understand where state will be stored for the workload.
- [ ] None of the above.

### Have you identified the performance targets and non-functional requirements for your workload?

- [x] You are able to predict general application usage.

### How are you ensuring that your workload is elastic and responsive to changes?

- [ ] The workload can scale horizontally in response to changing load.
- [ ] Have policies to scale in and scale down when the load decreases.
- [ ] Configured scaling policies to use the appropriate metrics.
- [ ] Automatically schedule autoscaling to add resources based on time of day trends.
- [ ] Autoscaling has been tested under sustained load.
- [ ] You have measured the time it takes to scale in and out.
- [x] **None of the above.**

### How have you accounted for capacity and scaling requirements of your workload?

- [ ] You have a capacity model for the workload.
- [ ] Capacity utilization is monitored and used to forecast future growth.
- [ ] A process for provisioning and de-provisioning capacity has been established.
- [ ] You have enabled auto-scaling for all PaaS and IaaS services that support it.
- [ ] You are aware of relevant Azure service limits and quotas.
- [x] **You have validated the SKU and configuration choices are appropriate for your anticipated loads.**
- [ ] There is a strategy in place to manage events that may cause a spike in load.
- [ ] None of the above.

### What considerations for performance efficiency have you made in your networking stack?

- [x] None of the above.

### How are you managing your data to handle scale?

- [ ] You know the growth rate of your data.
- [ ] You have documented plans for data growth and retention.
- [ ] Design for eventual consistency.
- [ ] You are using database replicas and data partitioning (sharding) as appropriate.
- [ ] Minimize the load on the data store.
- [ ] Normalize the data appropriately.
- [ ] Optimize database queries and indexes.
- [x] **None of the above.**

### How are you testing to ensure that you workload can appropriately handle user load?

- [x] None of the above.

### How are you benchmarking your workload?

- [x] None of the above.

### How have you modeled the health of your workload?

- [x] None of the above.

### How are you monitoring to ensure the workload is scaling appropriately?

- [x] None of the above.

### What common problems do you have steps to troubleshoot in your operations playbook?

- [x] None of the above.

# Exercise: Optimize Contact Management Application

As you have seen in the answers above, there are multiple ways to optimize performance for an application. Unfortunately, we cannot do them all, but at least we can take two high-priority measures in this area to improve our score.


## 1. Availability Zones

**Disclaimer: You are not required to implement this challenge for our application. It simply illustrates the importance of availability zones and how the implementation would look like.**

Let's pretend for the sake of the example, that our application has many requests. What would happen if, for example, the datacenter our application is running fails. Failures can range from software and hardware failures to events such as earthquakes, floods, and fires.

Currently, if something of the sorts would occur, our application would not be available anymore, thereby decreasing our performance. A way to protect our application is through [availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview). **Azure availability zones are physically separate locations within each Azure region**. To ensure resiliency, a minimum of three separate availability zones are present in all availability zone-enabled regions. West Europe and North Europe are examples of regions which support Availability Zones.

![Azure Availability Zones Overview](https://user-images.githubusercontent.com/114384858/215448689-0780726e-c6ce-4173-ba5a-6f1f238bc228.png)

Azure App Service Plan can be deployed into availability zones to help us achieve resiliency and reliability for your business-critical workloads. This architecture is also known as **zone redundancy**. Nonetheless, there are some requirements to deploy your App Service Plan in an availability zone.

- Both Windows and Linux are supported.
- Requires either Premium v2 or Premium v3 App Service plans.
- Minimum instance count of three is enforced.
- The platform will enforce this minimum count behind the scenes if you specify an instance count fewer than three.

To implement Availability Zones for our application, we would need to create a new App Service Plan, since pre-existing App Service plans can't be converted to use availability zones. Afterwards, we would need to [redeploy our application](https://learn.microsoft.com/en-us/azure/reliability/migrate-app-service) in the new App Service Plan.

To enable availability zones using the Azure CLI, include the --zone-redundant parameter when you create your App Service plan. You can also include the --number-of-workers parameter to specify capacity. If you don't specify a capacity, the platform defaults to three. Capacity should be set based on the workload requirement, but no less than three. A good rule of thumb to choose capacity is to ensure sufficient instances for the application such that losing one zone of instances leaves sufficient capacity to handle expected load.

``` shell
az appservice plan create --resource-group MyResourceGroup --name MyPlan --sku P1v2 --zone-redundant --number-of-workers 6
```

To create an App Service with availability zones using the Azure portal, enable the zone redundancy option during the "Create Web App" or "Create App Service Plan" step.

![Create ASP with Zone Redundancy in Azure Portal](https://user-images.githubusercontent.com/114384858/215450371-ab4452c8-73d9-441c-917d-464674e5af57.png)


## 2.

