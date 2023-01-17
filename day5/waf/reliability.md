# Reliability

A reliable workload is one that is both resilient and available. Resiliency is the ability of the system to recover from failures and continue to function. The goal of resiliency is to return the application to a fully functioning state after a failure occurs. Availability is whether your users can access your workload when they need to.

## Reliability guidance

The following topics offer guidance on designing and improving reliable Azure applications:

- Designing reliable Azure applications
- Design patterns for resiliency
- Transient fault handling
- Retry guidance for specific services

## Simple Contact Management

Since this application is not build for production reliability is not in the forefront. Starting off with using as little services and complexity and as cheap of an architecture as possible means that going through the Well Architected Framework's review we only have a score of 16/100.
The most important things needing consideration which were out of scope for this workshop are:
- have plans for backup, disaster recovery and data restoration
- create (geo-)redundancy

## Azure Developer College Questions

Answer the following questions:
1. How does your application logic handle exceptions and errors?
    - [ ] Have a method to handle faults that might take a variable amount of time to recover from.
    - [ ] Request timeouts are configured to manage inter-component calls.
    - [ ] Retry logic is implemented to handle transient failures, with appropriate back-off strategies to avoid cascading failures.
    - [ ] The application is instrumented with semantic logs and metrics.
    - [ ] None of the above.
1. What reliability allowances for security have you made?
    - [ ] The identity provider (AAD/ADFS/AD/Other) is highly available and aligns with application availability and recovery targets.
    - [ ] All external application endpoints are secured? i.e. Firewall, WAF, DDoS Protection Standard Plan, etc.
    - [ ] Communication to Azure PaaS services secured using Virtual Network Service Endpoints or Private Link.
    - [ ] Keys and secrets are backed-up to geo-redundant storage.
    - [ ] The process for key rotation is automated and tested.
    - [ ] Emergency access break glass accounts have been tested and secured for recovering from Identity provider failure scenarios.
    - [ ] None of the above.
1. What reliability allowances for operations have you made?
    - [ ] Application can be automatically deployed to a new region without any manual operations to recover from disaster scenarios.
    - [ ] Application deployments can be rolled-back and rolled-forward through automated deployment pipelines.
    - [ ] The lifecycle of the application is decoupled from its dependencies.
    - [ ] The time it takes to deploy an entire production environment is tested and validated.
    - [ ] None of the above.
1. How do you test the application to ensure it is fault tolerant?
    - [ ] The application is tested against critical Non-Functional requirements for performance. 
    - [ ] Load Testing is conducted with expected peak volumes to test scalability and performance under load. 
    - [ ] Chaos Testing is performed by injecting faults.
    - [ ] Tests are automated and carried out periodically or on-demand.
    - [ ] Critical test environments have 1:1 parity with the production environment. 
    - [ ] None of the above.

## Make the following adaptations to the application

We are not going to implement all changes that make this application production ready. But let us at least look at two adaptations.