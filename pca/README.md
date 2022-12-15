![vvs](../icon.png)

# Private Cloud Automation for VMware Cloud Foundation

## Table of Contents
1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [Get Started](#get-started)
4. [Issues](#issues)

## Introduction

This content is a companion to the [Private Cloud Automation for VMware Cloud Foundation](https://core.vmware.com/private-cloud-automation-vmware-cloud-foundation) validated solution which enables you to implement a modern cloud automation platform that delivers self-service automation, DevOps for infrastructure, and orchestration using vRealize Automation and VMware Cloud Foundation. 

## Requirements

### Powershell

If you want to use the PowerShell procedures to perform implementation and configuration procedures:

* Verify that your system has [Microsoft PowerShell 5.1](https://docs.microsoft.com/en-us/powershell/) installed. 

* Verify that your system has [VMware PowerCLI 12.7.0](https://code.vmware.com/web/tool/12.3.0/vmware-powercli) or higher installed.

* Install the [PowerValidatedSolutions](https://github.com/vmware-samples/power-validated-solutions-for-cloud-foundation) PowerShell module together with the supporting modules from the PowerShell Gallery by running the following commands. 

    ```powershell
    Install-Module -Name VMware.PowerCLI -MinimumVersion 12.7.0
    Install-Module -Name VMware.vSphere.SsoAdmin -MinimumVersion 1.3.8
    Install-Module -Name PowerVCF -MinimumVersion 2.2.0
    Install-Module -Name PowerValidatedSolutions -MinimumVersion 1.10.0
    ```

### Terraform

If you want to use the Terraform procedures to perform implementation and configuration procedures:

* Verify that your system has Terraform 1.2.0 or later installed. Learn more at [terraform.io](https://terraform.io).

* Verify the your system has a code editor installed. Microsoft Visual Studio Code is recommended. Learn more at [Visual Studio Code](https://code.visualstudio.com/).

* Install the Terraform Visual Studio Code extension 2.25.0 or later by HashiCorp for syntax highlighting and other editing features for Terraform files. Learn more at [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform).

### Packer

The implementation of the sample project refers to the use of Packer to create machine images using HashiCorp Packer and the Packer Plugin for VMware vSphere (`vsphere-iso`). Please visit the [github.com/vmware-samples/packer-examples-for vsphere](https://github.com/vmware-samples/packer-examples-for-vsphere) for a list of **examples** to create machine images with various guest operating systems.

By default, the resulting machine image artifacts are transferred to a vSphere Content Library as an OVF template. If an item of the same name exists in the target content library, Packer will update the existing item with the new OVF template. This method is extremely useful for vRealize Automation as image mappings do not need to be updated when an updated machine image is built.

## Get Started

### Download the Latest Release or Clone the Repository

Download the [**latest**](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/releases/latest) release or clone `main` for the latest updates.

**Example**:

```
git clone https://github.com/vmware-samples/validated-solutions-for-cloud-foundation.git
```

### Install the Terraform provider for vRealize Automation

The Terraform providers used in this repository are official and verified providers. Official providers are managed by HashiCorp. Verified providers are owned and maintained by members of the HashiCorp Technology Partner Program. HashiCorp verifies the authenticity of the publisher and the providers are listed on the [Terraform Registry](https://registry.terraform.io) with a verified tier label. 

Providers listed on the Terraform Registry can be automatically downloaded when initializing a working directory with `terraform init`. The Terraform configuration block is used to configure some behaviors of Terraform itself, such as the Terraform version and the required providers and versions.

However, some environments do not allow systems direct access to the Internet. The latest releases of the providers can be found on GitHub. You can download the appropriate version of the provider for your operating system using a command line shell or a browser and then prepare for "dark site" use.

Learn more about [Installing the Terraform Providers](docs/install-terraform-providers/README.md).

### Get Your Refresh Token for the vRealize Automation API

Before using the Terraform provider for vRealize Automation, you must request an API token that authenticates you for authorized API connections. The API token is also known as a "refresh token".

Learn more how to [Get Your Refresh Token for the vRealize Automation API](docs/refresh-token/README.md).

### Setup the Sample Project in vRealize Automation

Once you have deployed the **Private Cloud Automation for VMware Cloud Foundation** solution, you can use the  step-by-step implementation guidance to create a **sample** project in vRealize Automation after deploying the solution using both the UI and infrastructure-as-code procedures, such as PowerShell, Terraform, and Packer, where applicable.

No matter which path you choose to use - IaC or UI - the sample project implementation guidance can help you:

1. Learn how to get up an running with vRealize Automation.
2. Ensure the solution is ready for operations.
3. Learn how get started managing the desired state configuration of vRealize Automation using Terraform.

Learn more on how to [Configure a Sample Project in vRealize Automation](docs/sample-project/README.md).

## Issues

We welcome you to use the [GitHub Issues](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues) to report bugs or suggest enhancements.

In order to have a good experience with our community, we recommend that you read the [contributing guidelines](../CONTRIBUTING.md).
