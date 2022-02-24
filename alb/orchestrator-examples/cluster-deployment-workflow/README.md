# Cluster Deployment

Workflow Developed by: William Stoneman and Juan Aristizabal</br>
Tested Product Versions: vRO 7.6, vRO 8.1


## Table of Contents
1.	[Introduction](#Introduction)
1.	[Installation](#Installation)
1.	[Requirements](#Requirements)
1.	[Configuration](#Configuration)
1.	[Input Form](#InputForm)
1.	[Execution](#Execution)
1.	[Considerations](#Considerations)
1.	[Low Level Design](#LowLevelDesign)





# Introduction

The purpose of this Workflow is to deploy an AVI 3 Node Controller Cluster and configure all required settings to bring it to a stable usable state. The Workflow will first initiate the deployment of 3 Avi Controller Appliances to the desired vCenter environment, either utilizing a remote Linux host running ovftool or through a vRO vAPI connection to deploy using a Content Library Template.  The Workflow will then configure the following required settings: 

* Change Default Admin Password
* DNS Servers 
* NTP Servers 
* SMTP Configuration 
* Local/Remote SCP/AWS S3 Bucket Backup Configuration
* Licensing Configuration

# Installation

This Workflow and the Actions composed inside of it, will be included in the next release of the Avi Networks vRO Plugin. The plugin can be downloaded from the Avi Networks Github Repository “avi-vrealize-orchestrator-plugin” at https://github.com/avinetworks/avi-vrealize-orchestrator-plugin.

# Requirements

The following prerequisites are required to successfully utilize this Workflow:

* OVFTool Deployment - A Linux server with the ovftool application installed is required to deploy the Avi Appliances. If a Linux server is not available, the vRO Appliance can be used.

* Content Library Template Deployment - A vCenter Server Instance as well as a vAPI Metadata Endpoint are required in the vRO instance for the desired destination vCenter.

* An OVA template file for the Avi Controller Appliance. The template file needs to be put on the Linux Server or vRO Appliance.

* For the license configuration, either a Avi Networks License YML file or a VMWare License Key is required.

**[Back to top](#table-of-contents)**

# Configuration

The following configuration parameters need to be set to successful execute this Workflow:


* OVFTool Deployment - Update the following Workflow variables with the information for the Linux Server. If the local vRO Appliance is used, you must specify the IP Address or FQDN and NOT localhost.
	* **sshHost** – The FQDN or IP Address of the Linux Server.
	* **sshPort** – The SSH Port configured for the Linux Server. 
	* **sshUsername** – A Username that has access to run the ovftool commandlet.
	* **sshPassword** – The Password for the User.
	* **sshCommandPath** – The Command path for running the ovftool commandlet.

* Content Library Template Deployment - You will need to run the "Add a vCenter Server instance" and "Import vAPI metamodel" Workflows to create the required vCenter Endpoint connections.


**[Back to top](#table-of-contents)**


# Input Form

The following is a breakdown of the Input Form for this Workflow.


### VM Information:

-  **Vm Deployment Type:** *\<Drop Down - Deploy Using OVFTool, Deploy using COntent Library\>*</br>
-  **vCenter FQDN or IP Address:** *\<Text Field for vCenter Information\>*</br>
-  **vCenter Connection:** *\<Drop Down - List of vRO vCenter Endpoints\>*</br>  
-  **vCenter Username:** *\<Text Field for vCenter Username\>*</br>
-  **vCenter User Password:** *\<SecureString Field for vCenter Password\>*</br>
-  **vCenter Datacenter:** *\<Text Field for vCenter Datacenter\>*</br>
-  **vCenter Cluster:** *\<Text Field for vCenter Cluster\>*</br>
-  **vCenter Datastore:** *\<Text Field for vCenter Datastore\>*</br>
-  **vCenter Folder:** *\<Text Field for vCenter VM Folder\>*</br>
-  **vCenter VM Network:** *\<Text Field for vCenter Port Group\>*</br>
-  **Controller 1 VM Name:** *\<Text Field for COntroller 1 Name\>*</br>
-  **Controller 2 VM Name:** *\<Text Field for COntroller 2 Name\>*</br>
-  **Controller 3 VM Name:** *\<Text Field for COntroller 3 Name\>*</br>
-  **OVA File Path:** *\<Controller OVA Template File path on vRO Appliance\>*</br>
-  **Content Library Template Name:** *\<Controller OVA Template File from Content Library\>*</br> 
-  **VM Flavor:** *\<Drop Down - Small - 8vCPU - 24GB RAM, Medium - 16vCPU - 32GB RAM, Large - 24vCPU - 48GB RAM\>*</br> 
-  **VM Disk Size:** *\<Drop Down - 128GB, 256GB, 512GB, 1TB\>*</br>

### Cluster Information:

- **Certificate Silent Acceptance:** *\<Boolean\>*</br>
- **Controller 1 IP Address:** *\<Text Field for Controller 1 IP Address\>*</br>
- **Controller 2 IP Address:** *\<Text Field for Controller 2 IP Address\>*</br> 
- **Controller 3 IP Address:** *\<Text Field for Controller 3 IP Address\>*</br> 
- **Cluster VIP IP Address:** *\<Text Field for VIP IP address\>*</br> 
- **Controller IP Gateway:** *\<Text Field for IP Gateway\>*</br> 
- **Controller IP Mask:** *\<Text Field for IP Mask\>*</br> 
- **New Admin Password:** *\<SecureString Field for admin Password\>*</br> 
- **Avi Controller Version:** *\<Text Field for Avi Version\>*</br> 


### DNS Configuration:

- **DNS Servers:** *\<Array of Strings\>*</br> 


### NTP Configuration:

- **NTP Servers:** *\<Array of Strings\>*</br> 


### SMTP Configuration: 

- **From Email Address:** *\<Text Field for Email Address\>*</br> 
- **SMTP Type: Drop Down for SMTP Type:** *\<SMTP_LOCAL_HOST || SMTP_SERVER\>*</br> 
- **Mail Server FQDN or IP Address:** *\<Visiable only when SMTP_SERVER is selected\>*</br>
- **Mail Server Port:** *\<Default 25\>*</br> 
- **SMTP Server Username:** *\<Visible only whenSMTP_Server is selected\>*</br> 
- **SMTP Server Password:** *\<SecureString: Visible only when SMTP_Server is selected\>*</br> 


### Backup Configuration: 

- **Backup Passphrase:** *\<SecureString for Backup Passphrase\>*</br> 
- **Backup File Prefix:** *\<Text Field for Backup File Prefix\>*</br> 
- **Backup Type:** *\<Dropdown - Local, Remote, AWS S3 Bucket\>*</br> 
- **Backup Credential Object Name:** *\<Text Field for Backup Credential Object Name\>*</br> 
- **Backup SCP Host:** *\<Text Field for SCP Hostname\>*</br> 
- **Backup SCP Password:** *\<SecureString for Backup SCP Password\>*</br> 
- **Backup Path:** *\<Text Field for SCP path\>*</br> 
- **AWS Access Key:** *\<Text Field for AWS S3 Access Key\>*</br> 
- **AWS Secret Key:** *\<Text Field for AWS S3 Secret Key\>*</br> 
- **AWS Bucket Name:** *\<Text Field for AWS S3 Bucket Name\>*</br> 


### Licensing: 

- **License Type:** *\<Dropdown - VMWare License Key, Avi License File\>*</br> 
- **License File:** *\<Text Box for license YML file\>*</br> 
- **License Key:** *\<Array of Strings\>*</br> 



**[Back to top](#table-of-contents)**

# Execution

The flow of Actions for this workflow are:

1.	Deploy Avi Appliances
	A. Create ovftool commands for the 3 appliances.
		i. Execute ovftool commands on Linux Server. All 3 are run simultaneously.
	B. Deploy Appliances using Content Library Template. THe Appliances are deployed and configured one at a time.
3.	Create base URL for controller validation.
4.	Import Certificate into vRO certificate store for the 3 Controllers.
5.	Wait for Controllers to become ready. Run transient API calls against the “initial-data” API path. Wait for HTTP Response 200.
6.	Attach vROClient Object for Controller 1.
7.	Retrieve vROClient Object for Controller 1.
8.	Update admin default password.
9.	Configure System Configuration settings.
10.	Configure Backup Configuration settings.
11.	Initiate Cluster Configuration
12.	Wait for Cluster to be ready.
13.	Configure Licensing.
14.	Detach Controller 1 vROClient.
15.	Create base URL for VIP Interface.
16.	Attach vROClient Object for VIP.

If the Actions steps 8-13 fail, the remaining Cluster Deployment steps will need to be executed manually.

**[Back to top](#table-of-contents)**

# Considerations

The following are considerations that need to be understood when executing this Workflow:

* We have updated the Workflow to include Content Library support for deploying the 3 Avi Controller Nodes. This will require the end user to configure a vCenter and vAPI endpoint for the destination vCenter.

* If the OVFTool Deployment option is selected, then the deployed Controllers will be using the default "small" sizing (8 vCPU/ 24 GB with 128 GB of disk space). The ovftool command allows us to specify the RAM and vCPU, however we are not able to specify the provisioned disk space during deployment. The Content Library Deployment option allows the end user to specify the VM Sizing (SMALL: 8 vCPU/ 24 GB | MEDIUM: 16 vCPU/ 32 GB | LARGE: 24 vCPU/ 48 GB) and VM Disk Space (128 GB | 256 GB| 512 GB| 1 TB) for the deployed Avi Controllers.

**[Back to top](#table-of-contents)**

# Low Level Design

For a low level breakdown of the Workflow and the configured Actions, please see the attach “vRO - Cluster Deployment” PDF file.

