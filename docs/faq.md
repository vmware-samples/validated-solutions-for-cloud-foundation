---
title: Frequently Asked Questions
hide:
  - navigation
---

Find answers to frequently asked questions regarding VMware Validated Solutions including general questions that are applicable to all VMware Validated Solutions deployments, and also those specific to on-premises and hybrid deployments.

### General

??? note "What are VMware Validated Solutions?"

    VMware Validated Solutions are well-architected and validated implementations designed to help customers build secure, high-performing, resilient, and efficient infrastructure for their applications and workloads deployed on VMware Cloud Foundation.

    Each VMware Validated Solution comes with detailed design with design decisions, implementation guidance consisting of manual UI- based step-by-step procedures and, where applicable, automated steps using infrastructure-as-code. Individual VMware Validated Solutions may be supplemented with code samples & how-tos, customer success stories, and links to other published assets to provide a one-stop experience for our customers.

??? note "What goes into each VMware Validated Solution?"

    VMware Validated Solutions are relevant, easily discoverable, and consumable validated architecture for deploying value-enhancing solutions on top of the core VMware Cloud Foundation platform. These solutions are available to customers at no additional cost. Each VMware Validated Solution Guide provides all-encompassing documentation that delivers:

    Design Objectives
    Detailed Design with Design Decisions
    Planning and Preparation
    Implementation Procedures (UI and Infrastructure as Code where available)
    Operational Guidance
    Solution Interoperability

??? note "What are the benefits of VMware Validated Solutions?"

    The benefits of VMware Validated Solutions are as follows:

    Validated - VMware Validated Solutions are designed by VMware architects to help customers build secure, high-performing, resilient, and efficient infrastructure.
    Scalable - Easily scale infrastructure and applications running on VMware Cloud Foundation with technically validated, repeatable, and automated solutions.
    Secure - Security-centric designs that offer prescriptive guidance and enhance post-deployment hardening of VCF infrastructure.
    Lower costs - Infrastructure as code accelerates deployments through automated workflows that reduce manual labor and rework.
    Faster time to value - Rapidly implement solutions on top of VMware Cloud Foundation.

??? note "What are the pre-requisites to deploy a VMware Validated Solution?"

    VMware Validated Solutions requires an active VMware Cloud Foundation license (edition may matter per solution) with SDDC Manager. Each solution has additional pre-requisites listed in the solution, including specific versions of VMware Cloud Foundation, additional components as needed.

??? note "What benefit does Infrastructure-as-code provide for each VMware Validated Solution?"

    Infrastructure-as-code examples with PowerShell will assist customers in automating the deployment of solutions, with the following benefits:

    Accelerate deployments through automated workflows
    Code offers a time-saving alternative to UI-based step-by-step procedures.

??? note "How can I access these Validated Solutions and code samples?"

    VMware Validated Solutions are available at https://core.vmware.com/vmware-validated-solutions.

    The PowerShell module for VMware Validated Solutions (PowerValidatedSolutions) documentation is available online and the module can be downloaded from the PowerShell Gallery and it's documentation.

??? note "I see various tiles available for every VMware Validated Solution? What do these tiles indicate?"

    Each Validated solution has multiple tiles including:

    Before You Begin - Before you apply this validated solution your environment must have a certain VMware Cloud Foundation configuration.
    Design Objectives - Design objectives drive the prescriptive outcome of this validated solution to deliver a faster deployment suitable for use in production

    Detailed Design - The design considers the components of this validated solution. It includes numbered design decisions, and the justification and implications of each decision.

    Designs Decisions - Consolidated view of design decisions, their justification and implications of each decision.

    Planning and Preparation workbook - Before you start implementing the components of the validated solution, you must plan and gather inputs such as external service information (DNS, NTP), IP Addresses, host names and more.

    Implementation - Step-by-step procedures guide you through the implementation of this validated solution.

    Operational Guidance - After you complete the implementation of the validated solution, you perform common operations on the environment, such as examining the operational state of the components added to the environment during the implementation and updating the certificates and account passwords for these components.

    Solution Interoperability - Integrate the validated solution with components added to your VMware Cloud Foundation environment by other validated solutions. You can use such validated solutions for monitoring and alerting, logging, backup and restore, disaster recovery, and life cycle management with certain considerations.

??? note "In which order can I view these solution tiles?"

    Each Validated solution has multiple tiles and can be accessed in left to right order.

    - Design Objectives
    - Detailed design
    - Designs decisions
    - Implementation
    - Operational Guidance
    - Solution Interoperability

??? note "I see an **Estimated Time to Deploy** value in every solution. What does this value indicate?"

    **Estimated Time to Deploy** provides an approximate time to deploy the specific VMware Validated Solution following manual guidance and automated deployment code and procedures.

??? note "Are there solutions for the VMware SaaS Services?"

    On January 16, 2024, it was announced that the VMware Aria offerings are no available for purchase as SaaS services.

    The four solutions for the use of VMware Aria SaaS services with VMware Cloud Foundation were removed on January 30, 2024.

### On-Premises Validated Solutions

#### Identity and Access Management

??? note "What Identity Providers are used in the solution?"

    This solution uses Microsoft Active Directory over LDAPS (LDAP over SSL) as the identity provider for both vCenter Single Sign-On and Workspace ONE Access.

??? note "Why is Active Directory with Integrated Windows Authentication not used in the solution?"

    Active Directory with Integrated Windows Authentication is deprecated in vSphere 7.0 and later. It will be phased out in a future release of vSphere. See the vSphere 7.0 Release Notes and KB 78506.

??? note "Why is use of an external identity provider not used in the solution?"

    The use of an external identity provider is not included. However, the use is supported with the vSphere version used in this validated solution, but may introduce issues for other integrated solutions.

??? note "Is LDAP over SSL (LDAPS) required by the solution?"

    No. This validated solution is based on the use of LDAPS for the connections between vCenter Server to Microsoft Active Directory. LDAP can be used during the configuration if required; however, Microsoft recommends a hardened configuration for LDAP channel binding and LDAP signing on Active Directory domain controllers. For more information, see Microsoft Security Advisory ADV190023.

??? note "Does the solution provide any automation of initial deployment or on-going tasks?"

    Yes. This validated solution includes the optional use of Microsoft PowerShell cmdlets to perform many of the deployment and configuration procedures. You must first install the required PowerShell modules. The subsequent procedure options will set the minimally required variables and automate the procedure.

??? note "Do I need to join ESXi hosts to the Active Directory domain?"

    No. It's not required or recommended to join ESXi hosts in a VMware Cloud Foundation system to Active Directory. SDDC Manager manages the commissioning, configuration, and lifecycle of the ESXi hosts. In the event that direct access to a ESXi host is required, the Cloud Administrator can obtain the root or SERVICE account credentials to troubleshoot any issues with the ESXi host. However, there are circumstances when you must enable Active Directory as the authentication system by joining each ESXi host to an Active Directory domain. VMware Cloud Foundation supports the use of NFS version 4.1 (and version 3) as supplemental storage. With NFS version 4.1, ESXi supports the RPCSEC_GSS Kerberos mechanism authentication service. It allows the built-in NFS 4.1 client for ESXi to prove its identity to an NFS server before mounting an NFS share. The Kerberos security uses cryptography to work across an insecure network connection. To use Kerberos authentication, each ESXi host that mounts that mounts an NFS 4.1 datastore must be joined to the required Active Directory domain and the NFS Kerberos credentials must be set on each host.

??? note "Can I deploy this solution on Dell VxRail?"

    Yes.

#### Developer Ready Infrastructure

??? note "Which architecture model for VMware Cloud Foundation is used in the solution?"

    The solution is optimized for the standard architecture model with VMware Cloud Foundation instances consisting of a management domain and one or more workload domains.

    There are no known technical blockers to using this solution in the consolidated architecture, however you should consider the following:

    This combination is not explicitly tested by the VMware Validated Solution team.

    While the Planning & Preparation workbook will display the management domain values instead of the workload domain values, but there may be nuances where the process slightly differs in the management domain vs the workload domain.

    You should ensure Management Domain performance is not effected by leveraging resource pools and by regular monitoring of resource consumption.

??? note "Must I follow the naming and IP addressing format mentioned within the solution?"

    No. Customers should utilize the VMware Cloud Foundation Planning and Preparation Workbook to capture their own naming and IP addressing requirements and then use the workbook when following the implementation procedures.

??? note "Can I build on top of this with Tanzu Standard/Advanced/Enterprise?"

    This solution is loosely coupled with Tanzu Basic, but you may build on top of it using any of the tooling included with other Tanzu license bundles.

??? note "Must I use Microsoft Active Directory users and groups for Role Based Access Control? Can I just use vsphere.local users in vCenter Single Sign-On?"

    To deploy a compliant solution, you must use Active Directory users/groups for Role Based Access Control (RBAC). That said, vCenter SSO users will work fine. You should use an enterprise solution for access control to ensure auditability of logins and actions performed.

??? note "Does the solution provide any automation of initial deployment or on-going tasks?"

    Yes. This validated solution includes the optional use of Microsoft PowerShell cmdlets to perform many of the deployment and configuration procedures. You must first install the required PowerShell modules. The subsequent procedure options will set the minimally required variables and automate the procedure.

#### Health Reporting and Monitoring

??? note "Does this solution include the use of VMware Aria Operations SaaS?"

    No, the solution's design is based on the use of the on-premises deployment and configuration of VMware Aria Operations and the related integrations native to VMware Cloud Foundation.

    For VMware Aria Operations see: Intelligent Operations for VMware Cloud Foundation

??? note "Does this solution support more than one VMware Cloud Foundation instance?"

    Not at this time; however, the solution team has this on the roadmap.

??? note "If I have issues with the Python module, how can I report the issues?"

    Please open an issue in the GitHub repository.

??? note "If I don't want to use the sample appliance, is there a way for me to quickly build a compatible appliance?"

    Yes, the infrastructure-as-code example to automate the build of a virtual appliance in Open Virtualization Appliance (OVA) format with all the pre-requisites is available on GitHub.

    The appliance is built using HashiCorp Packer and the Packer Plugin for VMware using the vmware-iso builder.

#### Intelligent Logging and Analytics

??? note "Can I install/upgrade additional VMware Aria Operations for Logs content packs?"

    Yes.

??? note "Can I create custom widgets and dashboards in VMware Aria Operations for Logs?"

    Yes.

??? note "What are the benefits of VMware Cloud Foundation mode?"

    When VMware Aria Operations for Logs is deployed in VMware Cloud Foundation mode, the following benefits exist:

    - Workload domain integration
    - Password management
    - Core component integration
    - Content pack installation
    - Cross component integration

??? note "What are the limitations of VMware Cloud Foundation mode?"

    When VMware Aria Operations for Logs is deployed in VMware Cloud Foundation mode, the following limitations exist:

    Network placement is controlled.

??? note "After the deployment of VMware Aria Operations for Logs on VMware Cloud Foundation, how is the certificate generated and updated as a day-two action?"

    The certificate for VMware Aria Operations for Logs is managed by VMware Aria Suite Lifecycle via the Locker.

    SDDC Manager only manages the certificate for VMware Aria Suite Lifecycle in the VMware Aria Suite.

??? note "Does the solution allow the deployment of VMware Aria Operations for Logs at a baseline and then scale-up later, if needed?"

    Yes. VMware Aria Suite Lifecycle supports the scale-up operation for VMware Aria Operations for Logs nodes.

??? note "Does the solution provide any automation of initial deployment or on-going tasks?"

    Yes. This validated solution includes the optional use of Microsoft PowerShell cmdlets to perform many of the deployment and configuration procedures. You must first install the required PowerShell modules. The subsequent procedure options will set the minimally required variables and automate the procedure.

??? note "If an issue occurs with VMware Aria Operations for Logs and VMware issues a hot patch, is it okay to install the hot patch?"

    Yes, hot patches may be applied to the VMware Aria Operations for Logs as required using VMware Aria Suite Lifecycle. These hot patches may be download to VMware Aria Suite Lifecycle using the VMware Customer Connect integration or the binaries may be uploaded to VMware Aria Suite Lifecycle and then mapped in the user interface.

#### Intelligent Operations Management

??? note "Can I install additional VMware Aria Operations management packs?"

    Yes. You should however consider the existing sizing of VMware Aria Operations and scale out, as needed.

??? note "Can I deploy additional VMware Aria Operations cloud proxies?"

    Yes. They must be deployed using VMware Aria Suite Lifecycle and added to the same environment as the analytics cluster.

??? note "What are the benefits of VMware Cloud Foundation mode?"

    When VMware Aria Operations is deployed in VMware Cloud Foundation mode, the following benefits exist:

    - Load balancer automation
    - Password management
    - Management pack installation
    - Cross component integration (other VMware Validated Solutions)

??? note "What are the limitations of VMware Cloud Foundation mode?"

    When VMware Aria Operations is deployed in VMware Cloud Foundation mode, the following limitations exist:

    Network placement is controlled

??? note "Does this solution support the use of alternative to the VMware Cloud Foundation managed load balancer?"

    Some customers may have business or technical requirements to use alternative load balancer solution, such as, NSX Advanced Load Balancer (AVI), F5 Big-IP LTM, NetScaler, or others.

    VMware Aria Suite Lifecycle allows you to select a load balancer controller type:

    - VMware Cloud Foundation managed
    - NSX Advanced Load Balancer
    = Others

    The solution is authored to use VMware Cloud Foundation managed load balancer. This provides an automated deployment and configuration of the standalone NSX Tier-1 Gateway that is used for VMware Aria Suite load balancing. When a product is deployed by the VMware Aria Suite Lifecycle instance in Cloud Foundation-mode, the load balancer profiles, monitors, pools, and virtual servers are deployed to specification using a workflow step in the deployment request. VMware Aria Suite Lifecycle instructs SDDC Manager to create the load balancer objects on the standalone NSX Tier-1 Gateway that’s created during the initial deployment of VMware Aria Suite Lifecycle.

    If you have a requirement to use an alternative load balancer, you can do so.

    For NSX Advanced Load Balancer the configuration will be automated by VMware Aria Suite Lifecycle.

    For Others, please refer the load balancer configuration settings outlined in the detailed design and translate these to your required load balancer.

    After the deployment of VMware Aria Operations on VMware Cloud Foundation, how is the certificate generated and updated as a day-two action?
    The certificate for VMware Aria Operations is managed by VMware Aria Suite Lifecycle via the Locker.

    SDDC Manager only manages the certificate for VMware Aria Suite Lifecycle in the VMware Aria Suite.

??? note "Does the solution allow the deployment of VMware Aria Operations at a baseline and then scale-up later, if needed?"

    Yes. VMware Aria Suite Lifecycle supports the scale-up operation for VMware Aria Operations analytics cluster and cloud proxy nodes.

??? note "Does the solution provide any automation of initial deployment or on-going tasks?"

    Yes. This validated solution includes the optional use of Microsoft PowerShell cmdlets to perform many of the deployment and configuration procedures. You must first install the required PowerShell modules. The subsequent procedure options will set the minimally required variables and automate the procedure.

??? note "If an issue occurs with VMware Aria Operations and VMware issues a hot patch, is it okay to install the hot patch?"

    Yes, hot patches may be applied to the VMware Aria Operations as required using VMware Aria Suite Lifecycle.

    These hot patches may be download to VMware Aria Suite Lifecycle using the VMware Customer Connect integration or the binaries may be uploaded to VMware Aria Suite Lifecycle and then mapped in the user interface.

??? note "Does this solution enable VMware Aria Operations to support monitoring across multiple instances/sites?"

    Yes. You can configure cloud accounts for environments across instances/sites. Just be aware that firewall rules apply for the source/destination path.

#### Intelligent Network Visibility

??? note "Can this solution be implemented using a Consolidated architecture model for VMware Cloud Foundation?"

    The solution is optimized for the standard architecture model with VMware Cloud Foundation instances consisting of a management domain and one or more VI workload domains.

    This means the end to end implementation workflow has not been validated with a consolidated architecture and so some procedures may differ, however you may use still use the design with a consolidated deployment.

??? note "Can I deploy this Validated Solution on VMware Cloud Foundation for Dell VxRail?"

    Yes.

    After the deployment of VMware Aria Operations for Networks on VMware Cloud Foundation, how is the certificate generated and updated as a day-two action?

    The certificate for VMware Aria Operations is managed by VMware Aria Suite Lifecycle via the Locker.

    SDDC Manager only manages the certificate for VMware Aria Suite Lifecycle in the VMware Aria Suite.

??? note "Does the solution allow the deployment of VMware Aria Operations for Networks at a baseline and then scale-up later, if needed?"

    Yes. VMware Aria Suite Lifecycle supports the scale-up operation for VMware Aria Operations for Networks platform and collector nodes.

??? note "Does the solution provide any automation of initial deployment or on-going tasks?"

    Yes. This validated solution includes the optional use of Microsoft PowerShell cmdlets to perform some of the deployment and configuration procedures. You must first install the required PowerShell modules. The subsequent procedure options will set the minimally required variables and automate the procedure.

??? note "If an issue occurs with VMware Aria Operations for Networks and VMware issues a hot patch, is it okay to install the hot patch?"

    Yes, hot patches may be applied to the VMware Aria Operations for Networks as required using VMware Aria Suite Lifecycle.

    These hot patches may be download to VMware Aria Suite Lifecycle using the VMware Customer Connect integration or the binaries may be uploaded to VMware Aria Suite Lifecycle and then mapped in the user interface.

??? note "Does this solution enable VMware Aria Operations for Networks to support monitoring across multiple instances/sites?"

    Yes. You can configure data sources for environments across instances/sites. Just be aware that firewall rules apply for the source/destination path.

#### Private Cloud Automation

??? note "What products are included in this solution?"

    The solution includes VMware Aria Automation. VMware Aria Automation streamlines multi-cloud infrastructure and application delivery, enhances visibility and cross-functional collaboration, and provides continuous delivery and release automation. VMware Aria Automation is a bundled offering of VMware Aria Automation VMware Aria Automation Service Broker™, VMware Aria Automation Pipeline™, and VMware Aria Automation Config. VMware Aria Automation contains an embedded VMware Aria Automation Orchestrator™ instance.

    VMware Aria Automation Pipeline is out of scope for this VMware Cloud Foundation validated solution, but may be used to further extend the solution capabilities.

    VMware Aria Automation Config is out of scope for this VMware Cloud Foundation validated solution, but may be used to further extend the solution capabilities.

??? note "What clouds are supported in this solution?"

    The solution provides support for private cloud automation on VMware Cloud Foundation instances. You can extend the solution to connect hybrid (e.g., VMC) and public clouds (e.g., AWS, Azure, and GCP.)

??? note "What are the benefits of VMware Cloud Foundation mode?"

    When VMware Aria Automation is deployed in VMware Cloud Foundation mode, the following benefits are available:

    - Load balancer automation
    - Password management
    - Cross component integration

??? note "What are the limitations of VMware Cloud Foundation mode?"

    When VMware Aria Automation is deployed in VMware Cloud Foundation mode, the following limitations exist:

    - A three-node cluster is required
    - Network placement is controlled

??? note "Does this solution support the use of alternative to the VMware Cloud Foundation managed load balancer?"

    Some customers may have business or technical requirements to use alternative load balancer solution, such as, NSX Advanced Load Balancer (AVI), F5 Big-IP LTM, NetScaler, or others.

    VMware Aria Suite Lifecycle allows you to select a load balancer controller type:

    - VMware Cloud Foundation managed
    - NSX Advanced Load Balancer
    - Others

    The solution is authored to use VMware Cloud Foundation managed load balancer. This provides an automated deployment and configuration of the standalone NSX Tier-1 Gateway that is used for VMware Aria Suite load balancing. When a product is deployed by the VMware Aria Suite Lifecycle instance in Cloud Foundation-mode, the load balancer profiles, monitors, pools, and virtual servers are deployed to specification using a workflow step in the deployment request. VMware Aria Suite Lifecycle instructs SDDC Manager to create the load balancer objects on the standalone NSX Tier-1 Gateway that’s created during the initial deployment of VMware Aria Suite Lifecycle.

    If you have a requirement to use an alternative load balancer, you can do so.

    For NSX Advanced Load Balancer the configuration will be automated by VMware Aria Suite Lifecycle.
    For Others, please refer the load balancer configuration settings outlined in the detailed design and translate these to your required load balancer.

??? note "After the deployment of VMware Aria Automation on VMware Cloud Foundation, how is the certificate generated and updated as a day-two action?"

    The certificate for VMware Aria Automation is managed by VMware Aria Suite Lifecycle via the Locker. SDDC Manager only manages the certificate for VMware Aria Suite Lifecycle in the VMware Aria Suite.

??? note "If an issue occurs with VMware Aria Automation and VMware issues a hot patch, is it okay to install the hot patch?"

    Yes, hot patches may be applied to the VMware Aria Automation as required using VMware Aria Suite Lifecycle.

    These hot patches may be download to VMware Aria Suite Lifecycle using the VMware Customer Connect integration or the binaries may be uploaded to VMware Aria Suite Lifecycle and then mapped in the user interface.

??? note "Which architecture model for VMware Cloud Foundation is used in the solution?"

    The solution is optimized for the standard architecture model with VMware Cloud Foundation instances consisting of a management domain and one or more workload domains.

    You may use the design for the consolidated architecture models with the following exceptions and caveats:

    Do not set the No Access role on the management domain for the integration service accounts used for both VMware Aria Automation- and VMware Aria Automation Orchestrator-to-vSphere.

    Place the VMware Aria Automation virtual appliances within the resource pool for management workloads used in a consolidated architecture.

    Continue to deploy a three-node VMware Aria Automation cluster deployment with an NSX load-balancer. A single node VMware Aria Automation deployment is not available in a VMware Aria Suite Lifecycle environment that is enabled for VMware Cloud Foundation integration.

??? note "Does the solution allow the deployment of VMware Aria Automation at a baseline and then scale-up later, if needed?"

    Yes. VMware Aria Suite Lifecycle supports the scale-up operation for VMware Aria Automation nodes.

??? note "Does this solution enable VMware Aria Automation to support automated provisioning across multiple instances/sites?"

    Yes. You can configure cloud accounts for vSphere and NSX environments across instances/sites. Just be aware that firewall rules apply for the source/destination path.

    Additionally, VMware Aria Automation has support for cloud accounts hybrid (e.g., VMC) and public clouds (e.g., AWS, Azure, and GCP.)

??? note "Does the solution support the use of NSX Federation?"

    The VMware Aria Automation version in this solution does not fully support integration with NSX Federation and therefore does not support the consumption or provisioning of NSX Federation global policy objects; however, VMware Aria Automation can be deployed on federated NSX segments.

    Additionally, this solution does not use the VMware Cloud Foundation cloud account type. SDDC Manager does not manage NSX Federation and related NSX Global Manager instances. This solution is designed to allow support when NSX Federation is enabled for VMware Aria Automation consumption and provisioning of NSX Federation global policy objects.

??? note "Does the solution include the use of multi-tenancy with VMware Aria Automation?"

    The solution is authored to use multi-tenancy in VMware Aria Automation. You may adapt the solution to provide multi-tenancy as needed.

    Additional requirements will be required for DNS and multi-SAN certificates. Please refer to the VMware Aria Automation documentation.

??? note "What integrations are supported in this solution?"

    Solution interoperability includes:

    VMware Aria Operations to direct workload placement and assign the pricing policies for the monetary impact of deployments and their resources. You can also use VMware Aria Operations to display metrics, insights, optimization opportunities, and alerts in VMware Aria Automation.

    VMware Aria Automation is automatically enabled to send logs to VMware Aria Operations for Logs. You can use the VMware Aria Automation and VMware Aria Automation Orchestrator content packs for VMware Aria Operations for Logs to provide a consolidated summary of log events across VMware Aria Automation components for log analysis.

    After the deployment of VMware Aria Automation on VMware Cloud Foundation, it's configured to send logs to VMware Aria Operations for Logs using cfapi 9000. Can this be updated to cfapi 9543 for encryption?

    The default configuration is unencrypted. To ensure that the transmission of logs between VMware Aria Automation and VMware Aria Operations for Logs is encrypted using SSL, you must update the default configuration for VMware Aria Automation to send logs to VMware Aria Operations for Logs using the ingestion API, cfapi, on TCP port 9543 using the VMware Aria Automation vracli.

    For example, on the primary VMware Aria Automation cluster node, execute the following: vracli vrli set https://<vrli_ilb_fqdn>:9543.

#### Site Protection and Disaster Recovery

??? note "What management applications are protected as part of this solution?"

    - VMware Aria Suite Lifecycle Manager
    - VMware Aria Operations
    - VMware Aria Automation
    - Workspace ONE Access

??? note "Is NSX Federation required between the VMware Cloud Foundation instances?"

    Yes. NSX Federation is a key component of the design as it provides IP mobility for the management components.

??? note "How is load balancing provided on the recovery site?"

    A stand-by NSX load balancer is configured, but not connected, in the recovery site. In the case of a disaster recovery event, this stand-by load balancer is connected to provide load balancing services to the components that require it.

??? note "Is workload protection guidance included in the solution?"

    The solution provides the steps to setup Site Recovery Manager and vSphere Replication for a VI Workload Domain; however, protecting workloads is outside the scope as each workload will have specific requirements.

#### Advanced Load Balancing

??? note "What Load Balancing provider is used in the solution?"

    This solution uses VMware NSX Advanced Load Balancer (Avi Networks).

??? note "Does this solution provide any automation of initial deployment or on-going tasks?"

    Yes. This validated solution includes the optional use of automation tools such as VMware Aria Automation Orchestrator to perform many of the deployment and configuration procedures. You can access the automation workflows on GitHub.

??? note "Does this solution support the consolidated architecture?"

    Yes. This validated solution supports both consolidated and standard architectures.

??? note "Does this solution support the VMware Cloud Foundation on VxRail?"

    Yes. This validated solution supports both standalone and VCF on VxRail.

??? note "What ecosystem integration guidance is provided as part of this validated solution?"

    This validated solution guides customers to implement automated load balancing delivery in a vCenter Server environment with VMware NSX networking. A cloud connector of type NSX would be configured on the Avi Controller to deliver automated load balancing.

??? note "Can I utilize vCenter Server only or No-Access ecosystem integration to deliver load balancing on VMware Cloud Foundation using this validated solution?"

    Yes. This validated solution provides guidance to setup the VMware NSX Advanced Load Balancer control plane i.e., the Avi Controller cluster
    Provide ecosystem integration guidance for the NSX Cloud Connector integration for automated load balancing.

    Customers could choose to skip the ecosystem integration portion as presented in this validated solution and configure vCenter Server Only integration.

??? note "Can I use the Avi Controllers deployed through this validated solution to provide load balancing on baremetal servers that are hosted outside VMware Cloud Foundation?"

    Yes. VMware NSX Advanced Load Balancer is built to be a hybrid-cloud load balancing solution. A single Avi Controller cluster can manage and provide load balancing services across multiple hybrid-cloud ecosystems. Follow the guidance as per this validated solution, and then configure additional ecosystem integrations as required, not just limited to baremetal servers, but can also include native public clouds (AWS, Azure, GCP, etc.), OpenStack, container platforms such as Tanzu, OpenShift, etc.

??? note "What are the licensing requirements?"

    It is recommended to utilize Enterprise licenses for VMware NSX Advanced Load Balancer as it offers the best experience and a true enterprise-grade feature set including local load balancing, GSLB, Application Security & WAF, Container Ingress, and more. More information can be found at https://avinetworks.com/docs/20.1/nsx-license-editions/.

??? note "Where can I learn more about VMware NSX Advanced Load Balancer?"

    - https://www.vmware.com/products/nsx-advanced-load-balancer.html
    - https://info.avinetworks.com/workshops
    - https://www.youtube.com/c/Avinetworks/videos

### Hybrid Cloud Validated Solutions

#### Cloud-based Ransomware Recovery

??? note "Can this solution be implemented using a Consolidated architecture model for VMware Cloud Foundation?"

    The solution is optimized for the standard architecture model with VMware Cloud Foundation instances consisting of a management domain and one or more VI workload domains.

    This means the end to end implementation workflow has not been validated with a consolidated architecture and so some procedures may differ, however you may use still use the design with a consolidated deployment.

??? note "Can I deploy this Validated Solution on Dell VxRail System?"

    Yes.

#### Cross-Cloud Mobility

??? note "Can this solution be implemented using a Consolidated architecture model for VMware Cloud Foundation?"

    The solution is optimized for the standard architecture model with VMware Cloud Foundation instances consisting of a management domain and one or more VI workload domains.

    This means the end to end implementation workflow has not been validated with a consolidated architecture and so some procedures may differ, however you may use still use the design with a consolidated deployment.

??? note "Can I deploy this Validated Solution on Dell VxRail System?"

    Yes.
