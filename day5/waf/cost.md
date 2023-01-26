WIP

# Cost optimization

The cost optimization pillar provides principles for balancing business goals with budget justification to create a cost-effective workload while avoiding capital-intensive solutions. Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies.

## Cost Optimization guidance

A cost-effective workload is driven by business goals and the return on investment (ROI) while staying within a given budget. The principles of cost optimization are a series of important considerations that can help achieve both business objectives and cost justification. The following principles provide guidance to develop cost-effective Azure applications:

- Choose the correct resources
- Set up budgets and maintain cost constraints
- Dynamically allocate and de-allocate resources
- Optimize workloads, aim for scalable costs
- Continuously monitor and optimize cost management

To assess your workload using the principles found in the [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/architecture/framework/), reference the [Microsoft Azure Well-Architected Review](https://learn.microsoft.com/en-us/assessments/?id=azure-architecture-review&mode=pre-assessment).

## Simple Contact Management

In our case, we are building an application for testing purposes, and it is not ready for production. For instance, we did not really pay attention to our costs. Our result from the Well Architected Framework's review in this area is only 7/100!

The reason for this is that we are mostly using free or development pricing tiers and SKUs. Further, we also do not expect high workloads for our application (as it will likely be just us sending a couple of requests), and thus did not care much for estimating workloads. In a real-life scenario, however, modelling costs and workloads is extremely important. You should have a clear overview of the cost implications each service has. Also, you should have some measures to control the cost of your application i.e. get key people notified if a cost is expected to exceed budget or there are anomalies. 

## Well-Architected-Framework Review

Tami: just added all questions and answers I gave here - for those which I found interesting and easy to answer, I added all possible alternatives :p we can check together whether they make sense.

### How are you modeling cloud costs of this workload?

- [ ] Cloud costs are being modelled for this workload. 
- [ ] The price model of the workload is clear.
- [ ] Critical system flows through the application have been defined for all key business scenarios.
- [ ] There is a well-understood capacity model for the workload.
- [ ] Internal and external dependencies are identified and cost implications understood.
- [ ] Cost implications of each Azure service used by the application are understood.
- [ ] The right operational capabilities are used for Azure services.
- [ ] Special discounts given to services or licenses are factored in when calculating new cost models for services being moved to the cloud.
- [ ] Azure Hybrid Use Benefit is used to drive down cost in the cloud.
- [x] **None of the above**.

### How do you govern budgets and application lifespan for this workload?

- [ ] Budgets are assigned to all services in this workload.
- [ ] There is a cost owner for every service used by this workload.
- [ ] Cost forecasting is done to ensure it aligns with the budget.
- [ ] There is a monthly or yearly meeting where the budget is reviewed.
- [ ] Every environment has a target end-date.
- [ ] Every environment has a plan for migrating to PaaS or serverless to lower the all up cost and transfer risk.
- [ ] There is a clear understanding of how budget is defined.
- [ ] Budget is factored into the building phase.
- [ ] There is an ongoing conversation between the app owner and the business.
- [ ] There is a plan to modernize the workload.
- [ ] Azure Tags are used to enrich Azure resources with operational metadata.
- [x] **The application has a well-defined naming standard for Azure resources.**
- [ ] Role Based Access Control (RBAC) is used to control access to operational and financial dashboards and underlying data.
- [ ] None of the above.

### How are you monitoring costs of this workload?

- [x] None of the above.

### How do you optimize the design of this workload?

- [x] The application was built natively for the cloud.

### How do you ensure that cloud services are appropriately provisioned?

- [x] None of the above.

### What considerations for DevOps practices are you making in this workload?

- [x] There is awareness around how the application has been built and is being maintained (in house or via an external partner).

### How do you manage compute costs for this workload?

- [x] **Appropriate SKUs are used for workload servers.**
- [x] **Appropriate operating systems are used in the workload.**
- [ ] A recent review of SKUs that could benefit from Reserved Instances for 1 or 3 years or more has been performed.
- [ ] Burstable (B) series VM sizes are used for VMs that are idle most of the time and have high usage only in certain periods.
- [ ] VM instances which are not used are shut down.
- [ ] Spot virtual machines are used.
- [x] **PaaS is used as an alternative to buying virtual machines.**
- [ ] Costs are optimized by using the App Service Premium (v3) plan over the Premium (Pv2) plan.
- [ ] Zone to Zone disaster recovery is used for virtual machines.
- [ ] The Start/Stop feature in Azure Kubernetes Services (AKS) is used.
- [ ] None of the above.

### How do you manage networking costs for this workload?
- [x] None of the above.

### How do you manage storage and data costs for this workload?
- [x] None of the above.

# Exercise: Optimize Contact Management Application

As you have seen in the answers above, there are multiple ways to optimize costs for an application. Unfortunately, we cannot do them all, but at least we can take two high-priority measures in this area to improve our score.

<img width="841" alt="image" src="https://user-images.githubusercontent.com/114384858/214890025-2142dece-bf60-42b6-8260-8cb7163ceb69.png">


## 1. Configure Autoscale

For certain application, capacity requirements may swing over time. Autoscaling policies allow for less error-prone operations and cost savings through robust automation. For auto scaling, consider the choice of instance size. The size can significantly change the cost of your workload. Therefore, it is recommended to choose smaller instances (for instance, a 1-core instead of vs 4-core VM) where workload is highly variable and scale out (i.e. increase number of instances) to get the desired level of performance, rather than up. This choice will enable you to make your cost calculations and estimates granular. Below you can see a comparison of scalling out a 1-core VM by increasing the number of instances to 10, vs increasing instances of a 4-core VM to 3.

![image](https://user-images.githubusercontent.com/114384858/214886760-bcf41cf4-3300-4e8a-a9b2-516e46ecda1e.png)

### Autoscale Contact Management Application

Go to your AppService Plan and click on **Scale out (AppService Plan)**

Add a new **custom autoscale rule** for increasing to 2 instances, as well as to go back to 1 instance. In this example, we will create a scale-out rule which increases our instance by 1 if the average CPU usage is over 70% for 10 minutes. Further, we also need a rule to scale-in again. Thus, we added a rule to decrease the instance by 1 if average CPU usage is less than 50 percent. 

![image](https://user-images.githubusercontent.com/114384858/214888408-96908c22-95d2-411c-92c1-0f078d617dc6.png)

After creating both rules, it should look like this:

![image](https://user-images.githubusercontent.com/114384858/214887915-10535104-72ae-4312-bf48-cdc491b752b3.png)


## 2. Use Azure Monitor

**Azure Monitor Logs** is a feature of Azure Monitor that **collects and organizes log and performance data from monitored resources**. Several features of Azure Monitor store their data in Logs and present this data in various ways to assist you in monitoring the performance and availability of your cloud and hybrid applications and their supporting components. There's no direct cost for creating or maintaining a workspace. You're charged for the data sent to it, which is also known as data ingestion. You're charged for how long that data is stored, which is otherwise known as data retention.

Along with using existing Azure Monitor features, you can **analyze Logs data by using a sophisticated query language** that's capable of quickly analyzing millions of records. You might perform a simple query that retrieves a specific set of records or perform sophisticated data analysis to identify critical patterns in your monitoring data. Work with log queries and their results interactively by using Log Analytics, use them in alert rules to be proactively notified of issues, or visualize their results in a workbook or dashboard. 

![image](https://user-images.githubusercontent.com/114384858/214890385-125fd816-37d9-4d59-8de9-60b26ce612c9.png)

Azure Monitor Logs stores the data that it collects in one or more **Log Analytics workspaces. You must create at least one workspace to use Azure Monitor Logs. For a description of Log Analytics workspaces, see [Log Analytics workspace overview](https://learn.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview).**

TBC
