# NSX-T Cloud Deployment

Workflow Developed by: William Stoneman</br>
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

The purpose of this workflow is to deploy an NSX-T Cloud Connector on an Avi Cluster. When an NSX-T Cloud Connector is created through the Avi UI, it is required to configure atleast 1 Data Segment. However, when configuring an NSX-T Cloud through vRO you can configure the Cloud without this requirement. This is useful if seperate teams handle the individual parts of the Cloud. To configure the intial Data Segment or add additional Data Segments at a later time, the end user can utilize the NSX-T Cloud - Data Segments Workflow. 

This Workflow will also allow the end user to configure Segment IP Address Pools for both the Management and Data Networks. 

The flow of Action in this Workflow is as following:


# Installation

This Workflow and the Actions composed inside of it, will be included in the next release of the Avi Networks vRO Plugin. The plugin can be downloaded from the Avi Networks Github Repository “avi-vrealize-orchestrator-plugin” at https://github.com/avinetworks/avi-vrealize-orchestrator-plugin.

# Requirements

The following prerequisites are required to successfully utilize this Workflow:

* Credentials for the NSX-T Manager with Network Admin Role.

* Credentials for the Associated vCenter Server with appropriate permissions need to be setup based on the following documentation - https://avinetworks.com/docs/20.1/roles-and-permissions-for-vcenter-nsx-t-users/ 

* IP Pool information is required if the end user requires the Management or Data Segment IP Address Pools to be configured.

**[Back to top](#table-of-contents)**

# Configuration

The following configuration parameters need to be set to successful execute this Workflow:


* To successfully deploy an NSX-T Cloud on an Avi Cluster you must provide a network configuration for the SE Management interfaces. This requires an NSX-T VLAN or Overlay Transport Zone. If an overlay Transport Zone is provided then an associated T1 Router and Segment is then Required. If a VLAN based Transport Zone is provided, then only a VLAN Segment is required.

* As stated previously, you do not need to provide a Data Segment when creating the NSX-T cloud through this Workflow, and only a Trasnport Zone is required. However if the end user is required to configure Data Segments when deploying the NSX-T Cloud, then the same requirements need to be followed. If an overlay Transport Zone is provided then an associated T1 Router and Segment is then Required. If a VLAN based Transport Zone is provided, then only a VLAN Segment is required.


**[Back to top](#table-of-contents)**


# Input Form

The following is a breakdown of the Input Form for this Workflow.


### NSX-T Credentials:

-  **Avi Controller:** *\<Drop Down list of vro Clients\>*</br>
-  **NSX-T Credential Name:** *\<Text Field for NSX-T Credential Object Name\>*</br>
-  **NSX-T Manager:** *\<Text Field for NSX-T Manager IP Address or FQDN\>*</br>  
-  **NSX-T Username:** *\<Text Field for NSX-T Manager Username\>*</br>
-  **NSX-T Password:** *\<SecureString Field for NSX-T Manager User Password\>*</br>
-  **Verify NSX-T Password:** *\<SecureString Field for NSX-T Manager User Password\>*</br>

### vCenter Credentials:

- **vCenter Credential Name:** *\<Text Field for NSX-T Credential Object Name\>*</br>
- **vCenter Address (As entered in NSX-T Manager Compute Managers:** *\<Text Field for vCenter Manager IP Address or FQDN\>*</br>
- **vCenter Username:** *\<Text Field for vCenter Username\>*</br> 
- **vCenter Password:** *\<SecureString Field for vCenter User Password\>*</br> 
- **Verify vCenter Password:** *\<SecureString Field for vCenter User Password\>*</br> 
- **Content Library Name:** *\<Text Field for Content Library Name\>*</br> 

### NSX-T Cloud:

- **Cloud Name:** *\<Text Field for Cloud Connector Object Name\>*</br>
- **vCenter Name:** *\<Text Field for vCenter Connection Object Name\>*</br>
- **Avi Tenant Name:** *\<Text Field for Avi Cluster Tenant Name\>*</br>
- **Object Prefix Name:** *\<Text Field for NSX-T Object Prefix Name\>*</br>
- **SE management segment has DHCP enabled:** *\<heck Box to enable DHCP for SE Management IP Address\>*</br>
- **Management Transport Zone:** *\<Text Field for Management Network Transport Name\>*</br>
- **Management T1 Router Name (Optional):** *\<Text Field for Management Network T1 Router Name\>*</br>
- **Management Segment Name:** *\<Text Field for Management Network Segment Name\>*</br>
- **Create Mgmt Segment Pool?:** *\<Check Box to create Management Segment Pool\>*</br>
- **mgmt_Seg_Pool:** *\<Data Grid to provide Management Segment Pool Information\>*</br>
- **Data Network Transport Zone:** *\<Text Field for Data Network Transport Name\>*</br>
- **Data Network T1 Router Name (Optional):** *\<Text Field for Data Network T1 Router Name || OPIONAL\>*</br>
- **Data Network Segment Name (Optional):** *\<Text Field for Data Network Segment Name || OPTIONAL\>*</br>
- **Create Data Segment Pool?:** *\<Check Box to create Data Segment Pool || ONLY VISABLE IF Data Segment is specified\>*</br>
- **data_Seg_Pool:** *\<Data Grid to provide Data Segment Pool Information\>*</br>


**[Back to top](#table-of-contents)**

# Execution

The flow of Actions for this workflow are:

1. Retrieve Avi Cluster Connection
2. Create NSX-T Credential Object
3. Create vCenter Credential Object
4. Retrieve NSX-T Management Objects
	a. Validate NSX-T Credential Object by testing NSX-T Login
	b. Retrieve Transport Zone based on Input "Management Transport Zone"
	c. If "Management Transport Zone" is type OVERLAY, then retrieve T1 Router based on Input "Management T1 Router Name"
	d. Retrieve Segment based on Input "Management Segment Name" (and T1 Router IF Transport Zone is of Type Overlay)
	e. Return TZ, T1 and Segment UUID as Output Array
5. Retrieve NSX-T Data Objects
	a. Validate NSX-T Credential Object by testing NSX-T Login
	b. Retrieve Transport Zone based on Input "Data Network Transport Zone"
	c. IF "Data Network T1 Router Name" is Provided:
		i. If "Data Network Transport Zone" is type OVERLAY, then retrieve T1 Router based on Input "Data Network T1 Router Name"
	d. IF "Data Network Segment Name" is provided:
		i.Retrieve Segment based on Input "Data Network Segment Name" (and T1 Router IF Transport Zone is of Type Overlay)
	e. Return TZ, T1 and Segment UUID as Output Array
6. Retrieve vCenter Objects
	a. Retrieve configured vCenter from NSX-T based on Input "vCenter Address"
	b. Validate vCenter Credential Object by testing vCenter Login
	c. Retrieve Content Library based on Input "Content Library Name"
	d. Return vCenter and Content Library UUID as Output Array
7. Take Management, Data and vCenter Arrays:
	a. Form the JSON Object for the NSX-T Management Configuration
	b. Form the JSON Object for the NSX-T Data Configuration
	c. Take the Management Configuration and Data Configuration and form the Cloud Configuration JSON Object
	d. Execute API call to create NSX-T Cloud
	e. Form the JSON Object for the vCenter Connection
	f. Execute API call to create the vCenter Connection
8. IF Input "Create Mgmt Segment Pool?" is selected, then create the Management IP Address Pool on the Segment specified by Input "Management Segment Name" with configuration specified in Input "mgmt_Seg_Pool"
9. IF Input "Create Data Segment Pool?" is selected, then create the Management IP Address Pool on the Segment specified by Input "Data Network Segment Name" with configuration specified in Input "data_Seg_Pool"

If any of the actions fail, the end user will need to manaully complete the remaining steps.

**[Back to top](#table-of-contents)**

# Considerations

The following are considerations that need to be understood when executing this Workflow:

* The workflow is capable of creating the desired Management and/or Data Segment IP Address Pool. However, if the end user would like to utilize the Data Segment IP Address Pool for automated VS VIP selection, then an IPAM profile will need to be created and associated to the NSX-T Cloud.


**[Back to top](#table-of-contents)**

# Low Level Design

For a low level breakdown of the Workflow and the configured Actions, please see the attach “vRO - NSX-T Cloud Deployment” PDF file.

