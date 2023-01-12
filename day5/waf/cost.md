WIP

# Cost Optimization Overview

The cost optimization pillar provides principles for balancing business goals with budget justification to create a cost-effective workload while avoiding capital-intensive solutions. Cost optimization is about looking at ways to reduce unnecessary expenses and improve operational efficiencies.

Use the pay-as-you-go strategy for your architecture, and invest in scaling out, rather than delivering a large investment-first version. Consider opportunity costs in your architecture, and the balance between first mover advantage versus fast follow. Use the cost calculators to estimate the initial cost and operational costs. Finally, establish policies, budgets, and controls that set cost limits for your solution.

To assess your workload using the tenets found in the [Microsoft Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/architecture/framework/), reference the [Microsoft Azure Well-Architected Review](https://learn.microsoft.com/en-us/assessments/?id=azure-architecture-review&mode=pre-assessment).

We have done this review for our application and can highlight the following aspects:

## Well-Architected-Framework Review 

### How are you modeling cloud costs of this workload?

In our case, we are not really paying much attention to our costs. The reason for this is that we are mostly using free / developer plans and SKUs. Further, we also do not expect high workloads for our application (as it will likely be just us sending a couple of requests). In a real-life scenarion, however, modelling costs is extremely important. You should have a clear overview of the cost implications each service has. 

### How do you govern budgets and application lifespan for this workload?

Among the many different points to be considered, such as assigning budgets to each service, having cost owners, doing cost forecasting, having RBAC, or  conducting ongoing conversations between app owner and business, in our case we only contribute minimally to this by havinf well-defined naming standards for our resources. 

### How do you optimize the design of this workload?

### How do you manage compute costs for this workload?

As previously stated, for our application we did not really pay much attention to compute costs. As we focused fully on functionality. Nonetheless, according to the WAF, a way of managing compute costs is by using appropriate SKUs for our workloads - which we did. Also, we used PaaS instead of buying virtual machines. This were easy steps to take since our app was created with the cheapest SKUs and plan, and it is cloud native, which makes PaaS the best option in this case.



