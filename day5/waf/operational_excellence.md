# Operational excellence

The operational excellence pillar of the Well-Architected-Framework covers the operations processes that keep an application running in production. Deployments must be reliable and predictable. Automated deployments reduce the chance of human error. Fast and routine deployment processes won't slow down the release of new features or bug fixes. Equally important, you must be able to quickly roll back or roll forward if an update has problems.

## Operational excellence guidance

To achieve a higher competency in operations, consider and improve how software is:

- Developed
- Deployed
- Operated
- Maintained

Equally important, provide a team culture, which includes:

- Experimentation and growth
- Solutions for rationalizing the current state of operations
- Incident response plans

## Simple Contact Management

Since this application is not build for production operational excellence is not in the forefront. Starting off with using as little services and complexity and as cheap of an architecture as possible means that going through the Well Architected Framework's review we only have a score of 11/100.
The most important things needing consideration which were out of scope for this workshop are:

- Review, identify, and classify business critical applications
- Implement automated deployement process with rollback/roll-forward capabilities
- Improve monitoring
- Define RPO and REcovery time objective (RTO) and Recovery point objective (RPO) for your workload

## Well-Architected-Framework Review

### Have you identified and planned out the roles and responsibilities to ensure your workload follows operational excellence best practices?

- [ ] Development and operations processes are connected to a Service Management framework like ISO or ITIL
- [ ] There is no separation between development and operations teams.
- [ ] You have identified all broader teams responsible for operational aspects of the application and have established remediation plans with them for any issues that occur.
- [ ] Features and development tasks for the application are prioritized and executed on in a consistent fashion.
- [ ] You understand how the choices and desired configuration of Azure services are managed.
- [x] None of the above.

### What design considerations for operations have you made?

- [ ] You have documented any components that are on-premises or in another cloud.
- [ ] Deployed the application across multiple regions.
- [ ] Application is deployed across multiple regions in an active-passive configuration in alignment with recovery targets.
- [ ] Application platform components are deployed across multiple active regions.
- [ ] The workload is implemented with strategies for resiliency and self-healing.
- [ ] All platform-level dependencies are identified and understood.
- [x] None of the above.

### Have you defined key scenarios for your workload and how they relate to operational targets and non-functional requirements?

- [ ] Availability targets such as SLAs, SLIs and SLOs are defined for the application and key scenarios and monitored
- [ ] Availability targets such as SLAs, SLIs and SLOs for all leveraged dependencies are understood and monitored
- [ ] Recovery targets such as Recovery Time Objective (RTO) and Recovery Point Objective (RPO) are defined for the application and key scenarios
- [ ] The consequences if availability and recovery targets are not satisfied are well understood
- [ ] There are targets defined for the time it takes to perform scale operations
- [ ] Critical system flows through the application have been defined for all key business scenarios and have distinct availability, performance and recovery targets
- [ ] There are well defined performance requirements for the application and key scenarios
- [ ] Any application components which are less critical and have lower availability or performance requirements are well understood
- [x] None of the above.

### How are you monitoring your resources?

- [x] An Application Performance Management (APM) tool like Azure Application Insights is used to collect application level logs
- [x] Application logs are collected from different application environments
- [x] Log messages are captured in a structured format and can be indexed and searched
- [x] Application events are correlated across all application components
- [x] It is possible to evaluate critical application performance targets and non-functional requirements based on application logs and metrics
- [ ] End-to-end performance of critical system flows is monitored
- [ ] Black-box monitoring is used to measure platform services and the resulting customer experience.
- [ ] None of the above.

### How do you interpret the collected data to inform about application health?

- [ ] A log aggregation technology, such as Azure Log Analytics or Splunk, is used to collect logs and metrics from Azure resources
- [ ] Azure Activity Logs are collected within the log aggregation tool
- [x] Resource-level monitoring is enforced throughout the application
- [ ] Logs and metrics are available for critical internal dependencies
- [ ] Log levels are used to capture different types of application events.
- [ ] Critical external dependencies are monitored
- [ ] There are no known gaps in application observability that led to missed incidents and/or false positives.
- [ ] The workload is instrumented to measure customer experience.
- [ ] None of the above.

### How do you visualize workload data and then alert relevant teams when issues occur?

- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
- [ ]
