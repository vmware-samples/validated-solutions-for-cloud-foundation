# Python Module for VMware Cloud Foundation Health Monitoring in vRealize Operations

## Table of Contents

- [Health Reporting and Monitoring for VMware Cloud Foundation](#health-reporting-and-monitoring-vmware-cloud-foundation)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Requirements](#requirements)
  - [Implementation](#implementation)
  - [vRealize Operations Dashboards Preview](#vRealize-operations-dashboards-preview)
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

- [PowerShell Module for VMware Cloud Foundation Reporting](https://github.com/vmware/powershell-module-for-vmware-cloud-foundation-reporting) 2.1.0



## Implementation 

Follow the [Implementation of Health Reporting and Monitoring for VMware Cloud Foundation](https://docs.vmware.com/en/VMware-Cloud-Foundation/services/vcf-health-reporting-and-monitoring-v1/GUID-AD58BAF1-7DC9-4514-90B7-7E9FA2E9E5FA.html) from [Health Reporting and Monitoring for VMware Cloud Foundation](https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation)


## vRealize Operations Dashboards Preview
 
1. VCF Health Rollup
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Rollup1-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Rollup2-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Rollup3-min.png)

2. VCF Backup Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Backups1-min.png)
   
3. VCF Certificate Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Certificates1-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Certificates2-min.png)
   
4. VCF Compute Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Compute1-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Compute2-min.png)
   
5. VCF Connectivity Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Connectivity1-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Connectivity2-min.png)

6. VCF DNS Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/DNS1-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/DNS2-min.png)

7. VCF Hardware Compatibility
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/hw-compatibility-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/hw-compatibility-min2.png)
   
8. VCF Networking Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Networking-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Networking3-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Networking4-min.png)

9. VCF NTP Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/NTP-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/NTP3-min.png)
   
10. VCF Password Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Password1-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Password2-min.png)

11. VCF SDDC Manager and vCenter Services Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Services1-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Services2-min.png)
    
12. VCF Snapshot Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Snapshots1-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/Snapshots2-min.png)

13. VCF Storage Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/storage1-min.png)

14. VCF vSAN Health
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/vSAN-min.png)
![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/vSAN2-min.png)


## Known Issues
### 1. [Remove FQDN suffix dependency in the name when configuring an NSX-T cloud account in vRealize Operations](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/35)

Please make sure that your NSX-T account name is configured as mentioned in this issue. 

### 2. The vCenter Server name needs to be updated in VMware Cloud Foundation 4.4.x. The filters on the vReaize Operations dashboards depend on the name.

To set the Product Name for the vCenter Server, follow the below steps - 
1. Log in to the management domain vCenter Server at `https://<management_vcenter_server_fqdn>/ui` as `administrator@vsphere.local`.
2. In the `VMs and templates` inventory, expand the `management domain vCenter Server` tree and expand the management domain data center.
3. Select the first `management domain vCenter Server virtual machine` and select `Configure` tab.
4. In the `Settings` pane select `vApp Options`.
5. Click the `Edit` button. The `Edit vApp Options` dialog box opens.
6. If vApp options are disabled, select the `Enable vApp options` check box and click `OK`.
7. Click the `Details` tab and enter `VMware vCenter Server Appliance` as product name in the `Name` field.

### 3. Shades of red, green, and yellow may vary on vRealize Operations widgets.
Shades of red, green, and yellow may be different in different widgets but they represent the same thing. Ignore the shades as this is a vRealize Operations product limitation.


## Support

This Python module is not supported by VMware Support.

We welcome you to use the [GitHub Issues](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues) to report bugs or suggest enhancements.

In order to have a good experience with our community, we recommend that you read the [contributing guidelines](../CONTRIBUTING.md).

When filing an issue, please check existing open, or recently closed, issues to make sure someone else hasn't already
reported the issue.

Please try to include as much information as you can. Details like these are incredibly useful:

- A reproducible test case or series of steps.
- Any modifications you've made relevant to the bug.
- Anything unusual about your environment or deployment.

## License

Copyright 2023 VMware, Inc.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


