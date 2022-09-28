![vvs](../icon.png)

# Cloud-Based Intelligent Operations for VMware Cloud Foundation

## Table of Contents

- [Cloud-Based Intelligent Operations for VMware Cloud Foundation](#cloud-based-intelligent-operations-for-vmware-cloud-foundation)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Requirements](#requirements)
  - [Get Started](#get-started)
  - [Issues](#issues)

## Introduction

This content supports the [Cloud-Based Intelligent Operations for VMware Cloud Foundation](https://core.vmware.com/cloud-based-intelligent-operations-vmware-cloud-foundation) validated solution which enables a cloud-based infrastructure operations platform that provides intelligent operations for VMware Cloud Foundation and multi-cloud environments.

## Requirements

### Terraform

If you want to use the Terraform procedures to perform implementation and configuration procedures:

- Verify that your system has Terraform 1.2.0 or later installed. Learn more at [terraform.io](https://terraform.io).

- Verify the your system has a code editor installed. Microsoft Visual Studio Code is recommended. Learn more at [Visual Studio Code](https://code.visualstudio.com/).

- Install the Terraform Visual Studio Code extension 2.23.0 or later by HashiCorp for syntax highlighting and other editing features for Terraform files. Learn more at [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform).

## Get Started

### Download the Latest Release or Clone the Repository

Download the [**latest**](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/releases/latest) release or clone `main` for the latest updates.

**Example**:

```bash
git clone https://github.com/vmware-samples/validated-solutions-for-cloud-foundation.git
```

### Install the Terraform providers

The Terraform providers used in this repository are official and verified providers. Official providers are managed by HashiCorp. Verified providers are owned and maintained by members of the HashiCorp Technology Partner Program. HashiCorp verifies the authenticity of the publisher and the providers are listed on the [Terraform Registry](https://registry.terraform.io) with a verified tier label.

Providers listed on the Terraform Registry can be automatically downloaded when initializing a working directory with `terraform init`. The Terraform configuration block is used to configure some behaviors of Terraform itself, such as the Terraform version and the required providers and versions.

However, some environments do not allow systems direct access to the Internet. The latest releases of the providers can be found on GitHub. You can download the appropriate version of the provider for your operating system using a command line shell or a browser and then prepare for "dark site" use.

## Issues

We welcome you to use the [GitHub Issues](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues) to report bugs or suggest enhancements.

In order to have a good experience with our community, we recommend that you read the [contributing guidelines](../CONTRIBUTING.md).
