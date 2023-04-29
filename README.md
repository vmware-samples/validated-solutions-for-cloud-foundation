![vvs](icon.png)

# VMware Validated Solutions for VMware Cloud Foundation

## Introduction

A VMware Validated Solution is a technical validated implementation that is built and tested by VMware and VMware partners to help customers resolve common business use cases. VMware Validated Solutions are operationally and cost-effective, reliable, and secure. Each solution contains a detailed design, implementation, and operational guidance.

Learn more at [vmware.com/go/vvs](https://vmware.com/go/vvs).

This repository is a companion to the following validated solutions:

* [**Health Reporting and Monitoring for VMware Cloud Foundation**](https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation) A validated solution that provides health monitoring for the VMware Cloud Foundation components using HTML reports and custom dashboards, alerts, and notifications using vRealize Operations.

    The repository provides:

  * Python Module for VMware Cloud Foundation Health Monitoring in vRealize Operations.
  * vRealize Operations custom dashboards, alerts, notifications and super metric artifacts.


* [**Advanced Load Balancing for VMware Cloud Foundation**](https://core.vmware.com/advanced-load-balancing-vmware-cloud-foundation)
A validated solution enables you to build secure, high-performing, resilient, and efficient load balancing infrastructure for applications and workloads deployed on VMware Cloud Foundation. You  can leverage this solution to rapidly implement VMware NSX Advanced Load Balancer in a VMware Cloud Foundation environment to increase security, automation, and provide enterprise-grade developer-ready infrastructure for load balancing.

    The repository provides:

  * Infrastructure-as-code examples for the solution. This includes Terraform examples for the deployment and configuration of the solution.


* [**Cloud-Based Automation for VMware Cloud Foundation**](https://core.vmware.com/cloud-based-automation-vmware-cloud-foundation)  
A validated solution which enables a cloud-based infrastructure automation platform that delivers an agnostic self-service catalog for VMware Cloud Foundation and multi-cloud environments.

    The repository provides:

  * Infrastructure-as-code examples for the solution. This includes Terraform examples for the deployment and configuration of the solution.

  * Step-by-step implementation guidance to create a **sample** project in vRealize Automation Cloud after deploying the solution using both the UI and infrastructure-as-code where applicable.

  * A PowerShell menu to automate the population of the Terraform variables file using the Planning and Preparation Workbook and the execute the plans.

* [**Private Cloud Automation for VMware Cloud Foundation**](https://core.vmware.com/private-cloud-automation-vmware-cloud-foundation)  
A validated solution which enables you to implement a modern cloud automation platform that delivers self-service automation, DevOps for infrastructure, and orchestration using vRealize Automation and VMware Cloud Foundation.

    The repository provides:

  * Infrastructure-as-code examples for the solution. This includes Terraform examples for the deployment and configuration of the solution.

  * Step-by-step implementation guidance to create a **sample** project in vRealize Automation after deploying the solution using both the UI and infrastructure-as-code, such as PowerShell, Terraform, and Packer, where applicable.

## Get Started

### Download the  Release or Clone the Repository

Download the [**latest**](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/releases/latest) release or clone `main` branch for the latest updates.

**Example**:

```
git clone https://github.com/vmware-samples/validated-solutions-for-cloud-foundation.git
```

The directory structure of the repository.

```
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
│   ├── output-applicance
│   ├── scripts
│   ├── appliance-build.sh
│   └── ...
├── cba
│   ├── docs
│   ├── terraform-sample-project
│   ├── terraform-solution-implementation
│   ├── cbaTerraformMenu.ps1
│   └── README.md
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

* [Cloud-Based Automation for VMware Cloud Foundation](cba/README.md)

* [Health Reporting and Monitoring for VMware Cloud Foundation](hrm/README.md)

* [Private Cloud Automation for VMware Cloud Foundation](pca/README.md)

## Issues

We welcome you to use the [GitHub Issues](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues) to report bugs or suggest enhancements.

In order to have a good experience with our community, we recommend that you read the [contributing guidelines](CONTRIBUTING.md).
