WIP

# Cost Optimization Overview

The cost optimization pillar provides principles for balancing business goals with budget justification to create a cost-effective workload while avoiding capital-intensive solutions. Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies.

Use the pay-as-you-go strategy for your architecture, and invest in scaling out, rather than delivering a large investment-first version. Consider opportunity costs in your architecture, and the balance between first mover advantage versus fast follow. Use the cost calculators to estimate the initial cost and operational costs. Finally, establish policies, budgets, and controls that set cost limits for your solution.

To assess your workload using the tenets found in the [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/architecture/framework/), reference the [Microsoft Azure Well-Architected Review](https://learn.microsoft.com/en-us/assessments/?id=azure-architecture-review&mode=pre-assessment).

We have done this review for our application and can highlight the following aspects:

## Well-Architected-Framework Review 

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

**** 

In our case, we are not really paying much attention to our costs. The reason for this is that we are mostly using free / developer plans and SKUs. Further, we also do not expect high workloads for our application (as it will likely be just us sending a couple of requests). In a real-life scenarion, however, modelling costs is extremely important. You should have a clear overview of the cost implications each service has. 

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

****

Among the many different points to be considered, such as assigning budgets to each service, having cost owners, doing cost forecasting, having RBAC, or  conducting ongoing conversations between app owner and business, in our case we only contribute minimally to this by havinf well-defined naming standards for our resources. 

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

****

As previously stated, for our application we did not really pay much attention to compute costs. As we focused fully on functionality. Nonetheless, according to the WAF, a way of managing compute costs is by using appropriate SKUs for our workloads - which we did. Also, we used PaaS instead of buying virtual machines. This were easy steps to take since our app was created with the cheapest SKUs and plan, and it is cloud native, which makes PaaS the best option in this case.

### How do you manage networking costs for this workload?
- [x] None of the above.

### How do you manage storage and data costs for this workload?
- [x] None of the above.


