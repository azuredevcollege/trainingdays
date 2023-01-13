WIP

# Performance Efficiency

Performance efficiency is the **ability of your workload to scale to meet the demands placed on it by users in an efficient manner**. Before the cloud became popular, when it came to planning how a system would handle increases in load, many organizations intentionally provisioned oversized workloads to meet business requirements. This decision made sense in on-premises environments because it ensured capacity during peak usage. Capacity reflects resource availability (CPU and memory). Capacity was a major consideration for processes that would be in place for many years.

Just as you need to anticipate increases in load in on-premises environments, you need to expect increases in cloud environments to meet business requirements. One difference is that you may no longer need to make long-term predictions for expected changes to ensure you'll have enough capacity in the future. Another difference is in the approach used to manage performance.

## Well-Architected-Framework Review

### What design considerations have you made for performance efficiency in your workload?

- [ ] The workload is deployed across multiple regions.
- [x] Regions were chosen based on location, proximity to users, and resource type availability.
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
- [x] None of the above.

### How have you accounted for capacity and scaling requirements of your workload?

- [ ] You have a capacity model for the workload.
- [ ] Capacity utilization is monitored and used to forecast future growth.
- [ ] A process for provisioning and de-provisioning capacity has been established.
- [x] You have enabled auto-scaling for all PaaS and IaaS services that support it.
- [ ] You are aware of relevant Azure service limits and quotas.
- [ ] You have validated the SKU and configuration choices are appropriate for your anticipated loads.
- [ ] There is a strategy in place to manage events that may cause a spike in load.
- [ ] None of the above.

### What considerations for performance efficiency have you made in your networking stack?

- [x] None of the above.

### How are you managing your data to handle scale?

- [x] None of the above.

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
