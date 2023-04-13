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

- [PowerShell Module for VMware Cloud Foundation Reporting](https://github.com/vmware/powershell-module-for-vmware-cloud-foundation-reporting) 1.1.0



## Implementation 

Follow the [Implementation of Health Reporting and Monitoring for VMware Cloud Foundation](https://docs.vmware.com/en/VMware-Cloud-Foundation/services/vcf-health-reporting-and-monitoring-v1/GUID-AD58BAF1-7DC9-4514-90B7-7E9FA2E9E5FA.html) from [Health Reporting and Monitoring for VMware Cloud Foundation](https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation)


## vRealize Operations Dashboards Preview
 
1. VCF Health Rollup
<img width="500" alt="Rollup1" src="https://user-images.githubusercontent.com/8632869/231903283-25b9f1d9-2bc2-46d9-aeb2-466e13f00dac.png">
<img width="500" alt="Rollup2" src="https://user-images.githubusercontent.com/8632869/231901213-c90e2896-a1f8-40c6-8312-9a2e86ac7621.png">
<img width="500" alt="Rollup3" src="https://user-images.githubusercontent.com/8632869/231901245-3d6105b1-ce8d-42d2-ba05-38ae68a81e5d.png">


2. VCF Backup Health
<img width="500" alt="Backups1" src="https://user-images.githubusercontent.com/8632869/231901261-aba0efe0-f27f-43f0-b066-9f2c0eace83f.png">

3. VCF Certificate Health
<img width="500" alt="Certificate1" src="https://user-images.githubusercontent.com/8632869/231901291-7ef07992-e87c-4245-9b7f-737f6c5c80f4.png">
<img width="500" alt="Certificates2" src="https://user-images.githubusercontent.com/8632869/231901305-abd51770-82c1-4c61-b044-d1b12c89f8b0.png">

4. VCF Compute Health
<img width="500" alt="Compute1" src="https://user-images.githubusercontent.com/8632869/231901313-75b7b066-fd1f-45db-8a48-458ab716d36d.png">
<img width="500" alt="Compute2" src="https://user-images.githubusercontent.com/8632869/231901319-b3bbb2c1-bbd8-4a2d-abeb-8c6ae14e4d74.png">

5. VCF Connectivity Health
<img width="500" alt="Connectivity1" src="https://user-images.githubusercontent.com/8632869/231901325-93549932-4eda-4e09-aa87-e55bff04ed99.png">
<img width="500" alt="Connectivity2" src="https://user-images.githubusercontent.com/8632869/231901334-6ff1fe27-1f46-471e-be66-b996db0bc821.png">

6. VCF DNS Health
<img width="500" alt="DNS1" src="https://user-images.githubusercontent.com/8632869/231901345-0ab5f69c-43d2-4f30-b478-925ac8f4686a.png">
<img width="500" alt="DNS2" src="https://user-images.githubusercontent.com/8632869/231901357-48183756-cb1c-4417-878f-0671cccfbaf6.png">

7. VCF Hardware Compatibility
<img width="500" alt="Hardware Compatibility" src="https://user-images.githubusercontent.com/8632869/231901364-f725fa6d-b63a-40a2-be3f-c4363d44fc4d.png">
<img width="500" alt="Hardware Compatibility2" src="https://user-images.githubusercontent.com/8632869/231901374-a12e5a96-a903-45cf-a12b-3721a1db43a7.png">

8. VCF Networking Health
<img width="500" alt="Networking" src="https://user-images.githubusercontent.com/8632869/231901382-6195d9cd-c652-4081-98c8-a5b035db59e8.png">
<img width="500" alt="Networking3" src="https://user-images.githubusercontent.com/8632869/231901387-dbca0be4-bd79-4481-b314-a07df0f13916.png">
<img width="500" alt="Networking4" src="https://user-images.githubusercontent.com/8632869/231901392-e3c36d1a-59ab-4e6c-b479-132bc366d263.png">

9. VCF NTP Health
<img width="500" alt="NTP" src="https://user-images.githubusercontent.com/8632869/231901397-12d273e4-b6f7-4a7d-84dd-cfccda189887.png">
<img width="500" alt="NTP3" src="https://user-images.githubusercontent.com/8632869/231901408-fe41e1c4-bc8b-43c0-aa15-27ff3d0b7c09.png">

10. VCF Password Health
<img width="500" alt="Password1" src="https://user-images.githubusercontent.com/8632869/231901414-a57473c7-c849-41a8-8140-3de5ccc70a19.png">
<img width="500" alt="Password2" src="https://user-images.githubusercontent.com/8632869/231901417-6d41fb8a-ca61-4a1c-b290-2d1ee98d6fc0.png">

11. VCF SDDC Manager and vCenter Services Health
<img width="500" alt="Services1" src="https://user-images.githubusercontent.com/8632869/231901452-0c7a65bb-c1dd-4c30-9233-71bc081eef20.png">
<img width="500" alt="Services2" src="https://user-images.githubusercontent.com/8632869/231901455-8367bd29-4bd6-42ad-afd7-f55015008e12.png">


12. VCF Snapshot Health
<img width="500" alt="Snapshots" src="https://user-images.githubusercontent.com/8632869/231901481-6f2199e9-e288-4eaa-a9c8-4c235e63e662.png">
<img width="500" alt="Snapshot2" src="https://user-images.githubusercontent.com/8632869/231901468-a2d2b97e-a28c-411a-8e2e-4fa967b803e4.png">

13. VCF Storage Health
<img width="500" alt="image (11)" src="https://user-images.githubusercontent.com/8632869/231901974-e2244036-7b83-425f-95ea-897b1c1116a8.png">

14. VCF vSAN Health
<img width="500" alt="vSAN" src="https://user-images.githubusercontent.com/8632869/231901486-6d200fc7-28c7-4105-8706-727241ddb717.png">
<img width="500" alt="vSAN2" src="https://user-images.githubusercontent.com/8632869/231901498-0d13a7bc-ca39-4f8f-b6c6-c5751ff21986.png">


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


