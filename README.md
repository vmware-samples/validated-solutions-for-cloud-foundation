# VMware Validated Solutions for VMware Cloud Foundation

## Introduction

**VMware Validated Solutions** are technically validated implementations built and tested by VMware.

They are designed to help customers solve common business problems using [VMware Cloud Foundation](https://www.vmware.com/products/cloud-infrastructure/vmware-cloud-foundation) as the foundational infrastructure.

This repository is a companion to the following validated solutions:

* [**Health Reporting and Monitoring for VMware Cloud Foundation**](https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation)\

  A validated solution that provides health monitoring for the VMware Cloud Foundation components using HTML reports and custom dashboards, alerts, and notifications using VMware Aria Operations.

  The repository provides:

  * Python Module for VMware Cloud Foundation Health Monitoring in VMware Aria Operations.
  * Custom dashboards, alerts, notifications, and super metric artifacts in VMware Aria Operations.

* [**Advanced Load Balancing for VMware Cloud Foundation**](https://core.vmware.com/advanced-load-balancing-vmware-cloud-foundation)

  A validated solution enables you to build secure, high-performing, resilient, and efficient load balancing infrastructure for applications and workloads deployed on VMware Cloud Foundation. You  can leverage this solution to rapidly implement VMware NSX Advanced Load Balancer in a VMware Cloud Foundation environment to increase security, automation, and provide enterprise-grade developer-ready infrastructure for load balancing.

  The repository provides:

  * Infrastructure-as-code examples for the solution. This includes Terraform examples for the deployment and configuration of the solution.

* [**Private Cloud Automation for VMware Cloud Foundation**](https://core.vmware.com/private-cloud-automation-vmware-cloud-foundation)

  A validated solution which enables you to implement a modern cloud automation platform that delivers self-service automation, DevOps for infrastructure, and orchestration using Aria Automation and VMware Cloud Foundation.

  The repository provides:

  * Infrastructure-as-code examples for the solution. This includes Terraform examples for the deployment and configuration of the solution.

  * Step-by-step implementation guidance to create a **sample** project in Aria Automation after deploying the solution using both the UI and infrastructure-as-code where applicable.

## Get Started

### Clone the Repository

Clone `main` branch for the latest updates.

**Example**:

```bash
git clone https://github.com/vmware-samples/validated-solutions-for-cloud-foundation.git
```

The directory structure of the repository.

```bash
├── LICENSE
├── NOTICE
├── README.md
├── alb
│   ├── ansible-examples
│   ├── orchestrator-examples
│   └── README.md
├── appliance
│   ├── files
│   ├── manual
│   ├── output-appliance
│   ├── scripts
│   ├── appliance-build.sh
│   └── ...
├── hrm
│   ├── images
│   ├── releases
│   ├── source
│   └── README.md
└── pca
    ├── docs
    ├── scripts
    ├── terraform-examples
    └── README.md
```

### Navigate to the Companion Solution Content

* [Advanced Load Balancing for VMware Cloud Foundation](alb/README.md)

* [Health Reporting and Monitoring for VMware Cloud Foundation](hrm/README.md)

* [Private Cloud Automation for VMware Cloud Foundation](pca/README.md)

## Issues

We welcome you to use the [GitHub Issues](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues) to report bugs or suggest enhancements.

In order to have a good experience with our community, we recommend that you read the [contributing guidelines](CONTRIBUTING.md).
