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

To assess your workload using the tenets found in the [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/architecture/framework/), reference the [Microsoft Azure Well-Architected Review](https://learn.microsoft.com/en-us/assessments/?id=azure-architecture-review&mode=pre-assessment).

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


