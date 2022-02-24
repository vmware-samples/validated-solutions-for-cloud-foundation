# Cluster Upgrade

Workflow Developed by: William Stoneman and Juan Aristizabal</br>
Tested Product Versions: vRO 7.6, vRO 8.1</br>


## Table of Contents
1.	[Introduction](#Introduction)
1.	[Installation](#Installation)
1.	[Requirements](#Requirements)
1.	[Configuration](#Configuration)
1.	[Input Form](#Input-Form)
1.	[Execution](#Execution)
1.	[Considerations](#Considerations)
1.	[Low Level Design](#Low-Level-Design)



# Introduction

The purpose of this workflow is to upgrade an AVI Cluster. The Workflow will first initiate the upload of the upgrade packages(s), based on the upgrade path selected. We offer the following 3 Upgrade paths:

* Base Image Upgrade Only
* Patch Image Upgrade Only
* Base and Patch Image Upgrade


# Installation

This Workflow and the Actions composed inside of it, will be included in the next release of the Avi Networks vRO Plugin. The plugin can be downloaded from the Avi Networks Github Repository “avi-vrealize-orchestrator-plugin” at https://github.com/avinetworks/avi-vrealize-orchestrator-plugin.

# Requirements

The following prerequisites are required to successfully utilize this Workflow:

* A Linux server with the curl application installed is required to deploy the Avi Appliances. If a Linux server is not available, the vRO Appliance can be used.

* The upgrade package(s) based on the upgrade path selected. The upgrade file(s) need to be put on the Linux Server or vRO Appliance.


**[Back to top](#table-of-contents)**

# Configuration

The following configuration parameters need to be set to successful execute this Workflow:

* It is assumed that the specified Controller has already been added to vRO as a vROClient Object.

* Update the following Workflow variables with the information for the Linux Server. If the local vRO Appliance is used, you must specify the IP Address or FQDN and NOT localhost.
	* sshHost – The FQDN or IP Address of the Linux Server.
	* sshPort – The SSH Port configured for the Linux Server. 
	* sshUsername – A Username that has access to run the ovftool commandlet.
	* sshPassword – The Password for the User.
	* sshCommandPath – The Command path for running the ovftool commandlet.

* The Workflow will retrieve the backup configuration and save it to a file on the vRO Appliance. This is an on-demand one time backup and is used in case the upgrade causes a controller fault.

* Depending on the SE Error Response selection, the Workflow will either 
Monitor the upgrade and will NOT fail on upgrade error of Service Engines. After all SEs have either been successfully upgraded or encountered a failure, the Workflow will output all of the SE names, Upgrade Percentage and state. This will provide the end user with the required information to resolve any upgrade issue.

* Monitor the upgrade and FAIL the Workflow on any SE upgrade error. The Workflow will output all of the SE names, Upgrade Percentage and state. This will provide the end user with the required information to resolve any upgrade issue.


**[Back to top](#table-of-contents)**


# Input-Form

The following is a breakdown of the Input Form for this Workflow.

### General: 

-  **Controller:** *\<Dropdown list of vro Clients\>*</br>
-  **Controller Cluster Admin Password:** *\<SecureString Password Field\>*</br>
-  **Backup Passphrase:** *\<SecureString Password Field\>*</br> 
-  **Backup Directory on vRO Appliance:** *\<Text FIeld for vRO Appliance Directory\>*</br> 
-  **Verify Backup Passphrase:** *\<Contraint - Must match Backup Passphrase\>*</br> 
-  **SE Error Recovery Action:** *\<Dropdown list - Suspend Upgrade, Continue Upgrade\>*</br> 
-  **Upgrade Type:** *\<Dropdown list - Base Only Upgrade, Base and Patch Upgrade, Patch Only Upgrade\>*</br> 
-  **Base Upgrade File Location:** *\<Text Field for Full Path on Local VRO Appliance\>*</br> 
-  **Patch Upgrade File Location:** *\<Text Field of Full Path on Local VRO Appliance\>*</br> 
-  **Upgrade Version:** *\<Text Field for Upgrade release version\>*</br>
-  **Patch Upgrade Version:** *\<Text Field for Patch Upgrade release version\>*</br> 


**[Back to top](#table-of-contents)**

# Execution

The flow of Actions for this workflow are:

1.	Retrieve vROClient for provided Controller.
2.	Create Curl command for retrieving logon cookies.
3.	Execute Curl command on Linux Server.
4.	Determine Upgrade Path.
5.	Based on Upgrade Path, create Curl commands to upload upgrade package(s). Use the login cookies retrieved above for authentication.
6.	Execute Curl commands on Linux Server.
7.	Retrieve Cluster Leader IP Address and current firmware version.
8.	Create on demand one time backup. Save file to local vRO appliance.
9.	Initiate Cluster upgrade based on upgrade path selected, and the SE error response.
10.	Retrieve pre-upgrade VS status information. Store array to Workflow variable.
11.	Attach vROClient Object for Primary Controller.
12.	Process Upgrade validation for Controller Cluster nodes, and Service Engines. Wait for upgrade to complete Successfully.
13.	Detach Primary Controller vROClient.
14.	Detach Original Cluster Controller vROClient.
15.	Re attach Original Cluster Controller vROClient Object, with updated firmware version.
16.	Retrieve post-upgrade VS status information. Store array to Workflow variable.
17.	Compare pre and post VS status information. Alert of discrepancies.



If the Cluster nodes encounter an error during the upgrade process, the workflow will fail. The end User will need to manually resolve the issue and continue the upgrade. 

If the SE error response of Suspend is selected in the Input Form, when the Service Engines encounter an error during the upgrade process, the workflow will also fail. The end user will need to manually resolve the issue and continue the upgrade. However, if the SE error response of Continue is selected in the Input Form, the Workflow will not fail. It will continue with the upgrade process and present a final list of the Service Engines and the upgrade status. The end user will need to manually resolve and SEs that encounter an error during upgrade.

**[Back to top](#table-of-contents)**

# Considerations

The following are considerations that need to be understood when executing this Workflow:

* Our original design for this workflow was to have an input on the Input form for the source upgrade pkg. However, it seems that vRO has a max file size of 8 MB for attachments. We tried to utilize the vRO file methods to read the pkg file locally on the vRO appliance, but that caused the appliance to crash. The Avi Networks development team is currently testing additional processes to get this functionality built in to the plugin. For the file upload, we are utilizing curl commands to run API POST calls against the controllers "image" path to upload the files. This also poses a security risk, as we first need to use curl to collect session authentication cookies from the Controller and save them as workflow variables.


* Another configuration decision that needs to be taken into consideration before running the workflow, is the HA model selected for the SE group hosting the Virtual Services. If HA mode N+M in Buffer Mode is used, then the Virtual Services will be running on a single SE. When the SE is upgraded, the Virtual Services hosted on that SE will go down. We contemplated allowing the end user to select that the Virtual Services get scaled out, however we decided against that in the end. We felt that there were a lot of factors to consider in allowing for that configuration, and if the end user wanted to scale out the Virtual Services, it should be done manually.

**[Back to top](#table-of-contents)**

# Low-Level-Design

For a low level breakdown of the Workflow and the configured Actions, please see the attach “vRO - Cluster Upgrade” PDF file.
