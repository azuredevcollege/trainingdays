# Security

Think about security throughout the entire lifecycle of an application, from design and implementation to deployment and operations. The Azure platform provides protections against various threats, such as network intrusion and DDoS attacks. But you still need to build security into your application and into your DevOps processes.

## Security guidance

Consider the following broad security areas:

- Identity management
- Protect your infrastructure
- Application security
- Data sovereignty and encryption
- Security resources

## Simple Contact Management

Since this application is not build for production security is not in the forefront. Starting off with using as little services and complexity and as cheap of an architecture as possible means that going through the Well Architected Framework's review we only have a score of 19/100.
The most important things needing consideration which were out of scope for this workshop are:
- secure confidential data
- set up security within your Azure subscription and tenant by following the suggestions of CAF (Cloud Adoption Framework) and creating a landing zone
- set up key rotation and a seperate key store
- use managed identities and private links instead of connection strings and thelike

## Azure Developer College Questions

Answer the following questions:
1. Have you adopted a formal secure DevOps approach to building and maintaining software?
    - [ ] Formal DevOps approach to building and maintaining software in this workload was adopted.
    - [ ] DevOps security guidance based on industry lessons-learned, and available automation tools (OWASP guidance, Microsoft toolkit for Secure DevOps etc.) is leveraged. 
    - [ ] Gates and approvals are configured in DevOps release process of this workload.
    - [ ] Security team is involved in planning, design and the rest of DevOps process of this workload.
    - [ ] Deployments are automated and it's possible to deploy N+1 and N-1 version (where N is the current production). 
    - [ ] Code scanning tools are integrated as part of the continuous integration (CI) process for this workload and cover also 3rd party dependencies. 
    - [ ] Credentials, certificates and other secrets are managed in a secure manner inside of CI/CD pipelines.
    - [ ] Branch policies are used in source control management, main branch is protected and code reviews are required. 
    - [ ] Security controls are applied to all self-hosted build agents used by this workload (if any).
    - [ ] CI/CD roles and permissions are clearly defined for this workload.
    - [ ] None of the above.
1. Is the workload developed and configured in a secure way?
    - [ ] Cloud services are used for well-established functions instead of building custom service implementations.
    - [ ] Detailed error messages and verbose information are hidden from the end user/client applications. Exceptions in code are handled gracefully and logged. 
    - [ ] Platform specific information (e.g. web server version) is removed from server-client communication channels.
    - [ ] CDN (content delivery network) is used to separate the hosting platform and end-users/clients.
    - [ ] Application configuration is stored using a dedicated configuration management system (Azure App Configuration, Azure Key Vault etc.) 
    - [ ] Access to data storage is identity-based, whenever possible. 
    - [ ] Authentication tokens are cached securely and encrypted when sharing across web servers.
    - [ ] There are controls in place for this workload to detect and protect from data exfiltration.
    - [ ] None of the above.
1. How are you monitoring security-related events in this workload?
    - [ ] Tools like Microsoft Defender for Cloud are used to discover and remediate common risks within Azure tenants. 
    - [ ] A central SecOps team monitors security related telemetry data for this workload. 
    - [ ] The security team has read-only access into all cloud environment resources for this workload.
    - [ ] The security team has access to and monitor all subscriptions and tenants that are connected to the existing cloud environment, relative to this workload.
    - [ ] Identity related risk events related to potentially compromised identities are actively monitored.
    - [ ] Communication, investigation and hunting activities are aligned with the workload team. 
    - [ ] Periodic & automated access reviews of the workload are conducted to ensure that only authorized people have access?
    - [ ] Cloud application security broker (CASB) is leveraged in this workload.
    - [ ] A designated point of contact was assigned for this workload to receive Azure incident notifications from Microsoft.
    - [ ] None of the above.

## Make the following adaptations to the application

We are not going to implement all changes that make this application production ready. But let us at least look at two adaptations.