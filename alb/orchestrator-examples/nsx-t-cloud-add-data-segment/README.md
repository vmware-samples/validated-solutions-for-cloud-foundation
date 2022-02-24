# NSX-T Cloud - Add Data Segment

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

The Purpose of of this Workflow is to configure the intial Data Segment or add additional Data Segments to an exisiting NSX-T Cloud configured on an Avi Cluster. When an NSX-T Cloud Connector is created through the Avi UI, it is required to configure atleast 1 Data Segment. However, when configuring an NSX-T Cloud through vRO you can configure the Cloud without this requirement. This is useful if seperate teams handle the individual parts of the Cloud. Therefore, this Workflow can be run independantly or in conjunction with the NSX-T Cloud Deployment Workflow.

This Workflow will also allow the end user to configure Segment IP Address Pools for both the Management and Data Networks. 


# Installation

This Workflow and the Actions composed inside of it, will be included in the next release of the Avi Networks vRO Plugin. The plugin can be downloaded from the Avi Networks Github Repository “avi-vrealize-orchestrator-plugin” at https://github.com/avinetworks/avi-vrealize-orchestrator-plugin.

# Requirements

The following prerequisites are required to successfully utilize this Workflow:

* A NSX-T Cloud is required to exist on the Avi Cluster before running this workflow. The NSX-T Cloud does not have to have a Data segment configured, as this can be used to configure the initial Segment or additional Segments.

* IP Pool information is required if the end user requires the Data Segment IP Address Pools to be configured.

**[Back to top](#table-of-contents)**

# Configuration

This Workflow does not require any specific configuration to successfully execute.


**[Back to top](#table-of-contents)**


# Input Form

The following is a breakdown of the Input Form for this Workflow.


### General:

-  **Avi Controller:** *\<Drop Down list of vro Clients\>*</br>
-  **NSX-T Cloud:** *\<Drop Down list of Avi Cloud Connectors\>*</br>
-  **vCenter Name:** *\<Text Field for vCenter Connection Object Name\>*</br>
-  **Tier 1 Name:** *\<Text Field for Data Network T1 Router Name || OPIONAL\>*</br>
-  **Segment Name:** *\<Text Field for Data Network Segment Name || OPTIONAL\>*</br>
-  **Create Data Segment Pool?:** *\<Check Box to create Data Segment Pool\>*</br>
-  **data_Seg_Pool:** *\<Data Grid to provide Data Segment Pool Information\>*</br>




**[Back to top](#table-of-contents)**

# Execution

The flow of Actions for this workflow are:

1. Retrieve Avi Cluster Connection
2. Add Data Segment to NSX-T CLoud Object
	a. Retrieve NSX-T Cloud based on Input "NSX-T Cloud"
	b. Form the JSON Object for the Data Segment Configuration
	c. Take the Management Configuration and Data Configuration and append it to the retrieved Cloud Configuration JSON Object
	d. Execute API call to update NSX-T Cloud
3. IF Input "Create Data Segment Pool?" is selected, then create the Management IP Address Pool on the Segment specified by Input "Data Network Segment Name" with configuration specified in Input "data_Seg_Pool"

If any of the actions fail, the end user will need to manaully complete the remaining steps.

**[Back to top](#table-of-contents)**

# Considerations

The following are considerations that need to be understood when executing this Workflow:

* The workflow is capable of creating the desired Data Segment IP Address Pool. However, if the end user would like to utilize the Data Segment IP Address Pool for automated VS VIP selection, then an IPAM profile will need to be created and associated to the NSX-T Cloud.


**[Back to top](#table-of-contents)**

# Low Level Design

For a low level breakdown of the Workflow and the configured Actions, please see the attach “vRO - NSX-T Cloud - Data Segment” PDF file.

