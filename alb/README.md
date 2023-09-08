![vvs](../icon.png)

# Advanced Load Balancing for VMware Cloud Foundation

## Introduction

This content is a companion to the [Advanced Load Balancing for VMware Cloud Foundatio](https://core.vmware.com/private-cloud-automation-vmware-cloud-foundation) validated solution which enables you to build secure, high-performing, resilient, and efficient load balancing infrastructure for applications and workloads deployed on VMware Cloud Foundation. You  can leverage this solution to rapidly implement VMware NSX Advanced Load Balancer in a VMware Cloud Foundation environment to increase security, automation, and provide enterprise-grade developer-ready infrastructure for load balancing.

## Get Started

### Download the Release or Clone the Repository

Download the [**latest**](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/releases/latest) release or clone `main` for the latest updates.

**Example**:

```
git clone https://github.com/vmware-samples/validated-solutions-for-cloud-foundation.git
```

### Choose an Automation Path

This solution offers automation using either Aria Automation Orchestrator workflows or Ansible playbooks. Select a tool of choice and review the detailed information on how to execute either the sorkflow or the playbook.

The content layout provides easy navigation to the automation options.

```
├── LICENSE
├── NOTICE
├── README.md
└── alb
    ├── ansible-examples
    │    └── <playbook-name>
    │        └── <playbook-files>
    │        └── README.md
    ├── ansible-examples
    │    └── <workflow-name>
    │        └── <workflow-files>
    │        └── README.md
    └── README.md
```

This solution offers automation of the following procedures:

- 3 Node Cluster Deployment
- Cluster Upgrade
- Application or Controller Certificate Renewal
- Password Rotation  
  (Avi User, NSX-T Cloud Connector User, and vCenter SeerverUser)
- Failed Avi Node Replacement
- NSX-T CLoud Connector Deployment
- NSX-T Data Segment Creation
- Remote Authentication Configuration

## Issues

We welcome you to use the [GitHub Issues](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues) to report bugs or suggest enhancements.

In order to have a good experience with our community, we recommend that you read the [contributing guidelines](../CONTRIBUTING.md).
