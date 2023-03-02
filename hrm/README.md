# Python Module for VMware Cloud Foundation Health Monitoring in vRealize Operations

## Table of Contents

- [Health Reporting and Monitoring for VMware Cloud Foundation](#health-reporting-and-monitoring-vmware-cloud-foundation)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Requirements](#requirements)
  - [Implementation](#implementation)
  - [Known Issues](#known-issues)
  - [Support](#support)

## Introduction

This content supports the [Health Reporting and Monitoring for VMware Cloud Foundation](https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation) validated solution which enables the user to monitor the operational state of your VMware Cloud Foundation environment through custom dashboards, alerts, and notifications. These custom dashboards are intended to serve as an extension to native vRealize Operations dashboards and dashboards that are enabled via the respective management packs.

## Requirements

### Platforms

- [VMware Cloud Foundation](https://docs.vmware.com/en/VMware-Cloud-Foundation) 4.4 or later

### Operating Systems

- [VMware Photon OS](https://vmware.github.io/photon/) 3.0 and 4.0
- Microsoft Windows Server 2019 and 2022

### Python Version
- [Python 3.x](https://www.python.org/downloads/)

Follow the [Python Beginners Guide](https://wiki.python.org/moin/BeginnersGuide/Download) to download and install Python.

### Python Libraries

Install requried Python libraries by running the following commands on the host virtual machine:
  ```python
  pip install requests
  pip install setuptools
  pip install paramiko
  pip install maskpass==0.3.1
  
  ```

### PowerShell Editions and Versions
- PowerShell Core 7.2.0 or later
- Microsoft Windows PowerShell 5.1


### PowerShell Modules

- [PowerShell Module for VMware Cloud Foundation Reporting](https://github.com/vmware/powershell-module-for-vmware-cloud-foundation-reporting) 1.1.0 or later



## Implementation 

Follow the [Implementation of the Python Module for VMware Cloud Foundation Health Monitoring in vRealize Operations](https://docs.vmware.com/en/VMware-Cloud-Foundation/services/vcf-health-monitoring-v1/GUID-AD58BAF1-7DC9-4514-90B7-7E9FA2E9E5FA.html) from [Health Reporting and Monitoring for VMware Cloud Foundation](https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation)

## Known Issues
### 1. [HRM]Remove dependency of having FQDN as suffix in Account Name when configuring NSX-T account in vRealize Operations - https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/35 

Please make sure that your NSX-T account name is configured as mentioned in this issue. 

### 2. vCenter Name needs to be updated in VCF 4.4.x as filters on dashboards depend on it.

To set the Product Name for the vCenter Server, follow the below steps - 
1. Log in to the management domain vCenter Server at `https://<management_vcenter_server_fqdn>/ui` as `administrator@vsphere.local`.
2. In the `VMs and templates` inventory, expand the `management domain vCenter Server` tree and expand the management domain data center.
3. Select the first `management domain vCenter Server virtual machine` and select `Configure` tab.
4. In the `Settings` pane select `vApp Options`.
5. Click the `Edit` button. The `Edit vApp Options` dialog box opens.
6. If vApp options are disabled, select the `Enable vApp options` check box and click `OK`.
7. Click the `Details` tab and enter `VMware vCenter Server Appliance` as product name in the `Name` field.

### 3. Shades of Red, Green and Yellow may be different in different widgets
Shades of Red, Green and Yellow may be different in different widgets but they represent the same thing. Ignore the shades, this is a vRealize Operations limitation.



## Support

We welcome you to use the [GitHub Issues](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues) to report bugs or suggest enhancements.

In order to have a good experience with our community, we recommend that you read the [contributing guidelines](../CONTRIBUTING.md).



