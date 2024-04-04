# Python Module for VMware Cloud Foundation Health Monitoring in VMware Aria Operations

![PyPI](https://img.shields.io/pypi/v/vmware-cloud-foundation-health-monitoring?logo=python&logoColor=yellow&label=PyPI&labelColor=Grey&link=https%3A%2F%2Fpypi.org%2Fproject%2Fvmware-cloud-foundation-health-monitoring%2F)
&nbsp;&nbsp;
[![Downloads](https://static.pepy.tech/personalized-badge/vmware-cloud-foundation-health-monitoring?period=total&units=abbreviation&left_color=grey&right_color=green&left_text=DOWNLOADS)](https://pepy.tech/project/vmware-cloud-foundation-health-monitoring) &nbsp;&nbsp; [![Downloads](https://static.pepy.tech/personalized-badge/vmware-cloud-foundation-health-monitoring?period=month&units=international_system&left_color=grey&right_color=green&left_text=DOWNLOADS/WEEK)](https://pepy.tech/project/vmware-cloud-foundation-health-monitoring) &nbsp;&nbsp; [<img src="https://img.shields.io/badge/CHANGELOG-READ-blue?&logo=github&logoColor=white" alt="CHANGELOG" >][changelog]

## Table of Contents

- [Python Module for VMware Cloud Foundation Health Monitoring in VMware Aria Operations](#python-module-for-vmware-cloud-foundation-health-monitoring-in-vmware-aria-operations)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Requirements](#requirements)
    - [Platforms](#platforms)
    - [Operating Systems](#operating-systems)
    - [Python Version](#python-version)
    - [Python Libraries](#python-libraries)
    - [PowerShell Editions and Versions](#powershell-editions-and-versions)
    - [PowerShell Modules](#powershell-modules)
  - [Implementation](#implementation)
  - [Install the Python Module in a Disconnected Environment](#install-the-python-module-in-a-disconnected-environment)
    - [For Photon OS](#for-photon-os)
    - [For Windows Server](#for-windows-server)
  - [Updating the Python Module to the Latest Version](#updating-the-python-module-to-the-latest-version)
    - [For Photon OS](#for-photon-os-1)
    - [For Windows Server](#for-windows-server-1)
  - [VMware Aria Operations Dashboards Preview](#vmware-aria-operations-dashboards-preview)
  - [Known Issues](#known-issues)
  - [Support](#support)
  - [License](#license)

## Introduction

This content supports the [Health Reporting and Monitoring for VMware Cloud Foundation](https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation) validated solution which enables the user to monitor the operational state of your [VMware Cloud Foundation](https://docs.vmware.com/en/VMware-Cloud-Foundation) environment through custom dashboards, alerts, and notifications. These custom dashboards are intended to serve as an extension to native VMware Aria Operations dashboards and dashboards that are enabled using the respective management packs.

## Requirements

### Platforms

- VMware Cloud Foundation 5.1
- VMware Cloud Foundation 5.0
- VMware Cloud Foundation 4.5

### Operating Systems

- Microsoft Windows Server 2019 and 2022
- [VMware Photon OS](https://vmware.github.io/photon/) 3.0 and 4.0

### Python Version

- [Python 3.x](https://www.python.org/downloads/)

Follow the [Python Beginners Guide](https://wiki.python.org/moin/BeginnersGuide/Download) to download and install Python.

### Python Libraries

Install required Python libraries by running the following commands on the host virtual machine:

```python
pip install requests
pip install setuptools
pip install paramiko
pip install maskpass==0.3.1
```

### PowerShell Editions and Versions

- PowerShell Core 7.2.0 or later

### PowerShell Modules

- [PowerShell Module for VMware Cloud Foundation Reporting](https://github.com/vmware/powershell-module-for-vmware-cloud-foundation-reporting) - latest version

## Implementation

Follow the [Implementation of Health Reporting and Monitoring for VMware Cloud Foundation](https://docs.vmware.com/en/VMware-Cloud-Foundation/services/vcf-health-reporting-and-monitoring-v1/GUID-AD58BAF1-7DC9-4514-90B7-7E9FA2E9E5FA.html) from [Health Reporting and Monitoring for VMware Cloud Foundation](https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation)

## Install the Python Module in a Disconnected Environment

For disconnected environments (_e.g._, dark-site, air-gapped), you can save the Health Reporting and Monitoring Python module and its dependencies from the PyPI using the below instructions.

### For Photon OS

- On the target system, create a directory to save the Python modules

  ```console
  mkdir -p /opt/vmware/hrm-modules
  ```

- From a system with an Internet connection, make a modules directory and create a new file `requirements.txt` inside it.

  ```console
  mkdir -p /home/hrm-modules/
  cd /home/hrm-modules/
  vi requirements.txt
  ```

- Add below content to the `requirements.txt` file and save it.

  ```console
  requests
  setuptools
  paramiko
  maskpass==0.3.1
  ```

- Create another file `module.txt` in the same location.

  ```console
  vi module.txt
  ```
  
- Add below content to the `module.txt` file and save it.

  ```console
  vmware-cloud-foundation-health-monitoring
  ```
  
- From a system with an Internet connection, save the module and its dependencies from PyPI by running the following commands in the terminal:

  ```console
  pip download -r module.txt
  pip download -r requirements.txt
  ```

- From the system with an Internet connection, copy the module and its dependencies to a target system by running the following commands in the terminal:

  ```console
  scp -r /home/vcf/hrm-modules/* username@remote_host:/opt/vmware/hrm-modules/
  ```
  
- On the target system, install the module and its dependencies by running the following commands in the terminal:

  ```console
  cd /opt/vmware/hrm-modules
  pip install -r requirements.txt --no-index --find-links .
  pip install -r module.txt --no-index --find-links . -t /opt/vmware/hrm-<sddc_manager_vm_name>
  ```

### For Windows Server

- From a system with an Internet connection, make a modules folder `F:\hrm-modules`.
- Create a new file `requirements.txt` inside the modules folder.
- Add the below content to the `requirements.txt` file and save it.

  ```console
  requests
  setuptools
  paramiko
  maskpass==0.3.1
  ```

- In the modules folder `f:\hrm-modules`, create a new file `module.txt`
- Add below content to `module.txt` file and save it.

  ```console
  vmware-cloud-foundation-health-monitoring
  ```

- From a system with an Internet connection, save the module and its dependencies from PyPI by running the following commands from cmdline:

  ```console
  cd f:\hrm-modules
  pip download -r module.txt 
  pip download -r requirements.txt
  ```

- From the system with the Internet connection, copy the module and its dependencies to a target system by running the following commands in the PowerShell console:

  ```powershell
  Copy-Item -Path F:\hrm-modules\* -Destination '\\<destination_host>\C$\vmware\hrm-modules
  ```

- On the target system, install the module and its dependencies by running the following commands in the terminal:

  ```console
  cd c:\vmware\hrm-modules
  pip install -r requirements.txt --no-index --find-links .
  pip install -r module.txt --no-index --find-links . -t c:\vmware\hrm-<sddc_manager_vm_name>
  ```

**Once the Python modules are installed, continue to follow the [Implementation of Health Reporting and Monitoring for VMware Cloud Foundation](https://docs.vmware.com/en/VMware-Cloud-Foundation/services/vcf-health-reporting-and-monitoring-v1/GUID-AD58BAF1-7DC9-4514-90B7-7E9FA2E9E5FA.html) from [Health Reporting and Monitoring for VMware Cloud Foundation](https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation)**

## Updating the Python Module to the Latest Version

### For Photon OS

- Log in to the host virtual machine at `<host_virtual_machine_fqdn>:22` as the `root` user by using a Secure Shell (SSH) client.

- Update the Python Module for Health Reporting and Monitoring in VMware Aria Operations.

  ```console
  pip install vmware-cloud-foundation-health-monitoring --target=/opt/vmware/hrm-<sddc_manager_vm_name> --upgrade
  ```  

- Provide execute permissions to the files in the `hrm-<sddc_manager_vm_name>` directory.

  ```console
  chmod -R 755 /opt/vmware/hrm-<sddc_manager_vm_name>
  ```  

- Switch to the `hrm-<sddc_manager_vm_name>/main` directory.

  ```console
  cd /opt/vmware/hrm-<sddc_manager_vm_name>/main
  ```

- Edit the `env.json` file and configure the values according to your VMware Cloud Foundation Planning and Preparation Workbook.

  ```console
  vi env.json
  ```

- Encrypt the service account passwords.

  ```console
  python encrypt-passwords.py
  ```

- Enter the password for the VMware Aria Operations service account.
- Enter the password for the SDDC Manager service account.
- Enter the password for the SDDC Manager appliance local user.
- Repeat this procedure for each VMware Cloud Foundation instance.

### For Windows Server

- Log in to the host virtual machine at `<host_virtual_machine_fqdn>` as the `Administrator` user by using a Remote Desktop Connection (RDC) client and open a PowerShell console.
- Start Windows Command Prompt.
- Update the Python Module for Health Reporting and Monitoring in VMware Aria Operations.

  ```console
  pip install vmware-cloud-foundation-health-monitoring --target=C:\vmware\hrm-<sddc_manager_vm_name>\ --upgrade
  ```

- Change to the `hrm-<sddc_manager_vm_name>\main` folder.

  ```console
  cd c:\vmware\hrm-<sddc_manager_vm_name>\main
  ```

- Edit the `env.json` file and configure the values according to your VMware Cloud Foundation Planning and Preparation Workbook.

  ```console
  notepad env.json
  ```

- Encrypt the service account passwords.

  ```console
  python encrypt-passwords.py
  ```

- Enter the password for the VMware Aria Operations service account.
- Enter the password for the SDDC Manager service account.
- Enter the password for the SDDC Manager appliance local user.
- Repeat this procedure for each VMware Cloud Foundation instance.

## VMware Aria Operations Dashboards Preview

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

    ![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/storage2-min.png)

    ![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/connected-roms-min.png)

14. VCF vSAN Health

    ![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/vSAN-min.png)

    ![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/vSAN2-min.png)

15. VCF Version Health

    ![](https://raw.githubusercontent.com/vmware-samples/validated-solutions-for-cloud-foundation/main/hrm/images/version-min.png)

## Known Issues

1. [Remove FQDN suffix dependency in the name when configuring an NSX-T cloud account in VMware Aria Operations](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/35)

    Please make sure that your NSX-T account name is configured as mentioned in this issue.

2. The vCenter Server name needs to be updated in VMware Cloud Foundation 4.x. The filters on the VMware Aria Operations dashboards depend on the name.

    To set the Product Name for the vCenter Server, follow the below steps:

    1. Log in to the management domain vCenter Server at `https://<management_vcenter_server_fqdn>/ui` as `administrator@vsphere.local`.
    2. In the `VMs and templates` inventory, expand the `management domain vCenter Server` tree and expand the management domain data center.
    3. Select the first `management domain vCenter Server virtual machine` and select `Configure` tab.
    4. In the `Settings` pane select `vApp Options`.
    5. Click the `Edit` button. The `Edit vApp Options` dialog box opens.
    6. If vApp options are disabled, select the `Enable vApp options` check box and click `OK`.
    7. Click the `Details` tab and enter `VMware vCenter Server Appliance` as product name in the `Name` field.

3. Shades of red, green, and yellow may vary on VMware Aria Operations widgets

    Shades of red, green, and yellow may be different in different widgets but they represent the same thing. Ignore the shades as this is a VMware Aria Operations product limitation.

## Support

This Python module is not supported by VMware Support Services.

We welcome you to use the [GitHub Issues](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues) to report bugs or suggest enhancements.

In order to have a good experience with our community, we recommend that you read the [contributing guidelines](../CONTRIBUTING.md).

When filing an issue, please check existing open, or recently closed, issues to make sure someone else hasn't already
reported the issue.

Please try to include as much information as you can. Details like these are incredibly useful:

- A reproducible test case or series of steps.
- Any modifications you've made relevant to the bug.
- Anything unusual about your environment or deployment.

## License

Copyright 2023-2024 Broadcom. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[//]: Links

[changelog]: CHANGELOG.md
