# Cluster Replacement

Workflow Developed by: William Stoneman</br>
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

The purpose of this workflow is to allow the end user to replace a failed Avi Cluster Node. This Workflow allows for the Node to be re deployed using either the ovfTool or Conten Library deployment mechanism.

To complete the node removal, the Avi Cluster is put into single node Cluster configuration utilizing the current Leader Node. ONce the failed Node is re deployed, the cluster is built again using the original Leader and second Follower Controllers


# Installation

This Workflow and the Actions composed inside of it, will be included in the next release of the Avi Networks vRO Plugin. The plugin can be downloaded from the Avi Networks Github Repository “avi-vrealize-orchestrator-plugin” at https://github.com/avinetworks/avi-vrealize-orchestrator-plugin.

# Requirements

It is assumed that the specified Controller has already been added to vRO as a vROClient Object.

There are no other pre requisite configuration requirements for this Workflow.


**[Back to top](#table-of-contents)**

# Configuration

This Workflow does not require any specific configuration to successfully execute.


**[Back to top](#table-of-contents)**


# Input-Form

The following is a breakdown of the Input Form for this Workflow.

### General: 
- **Avi Controller:** *\<Drop Down list of vro Clients\>*</br>
- **Deployment Type:** *\<Drop Down list of Deployment Types - ovfTool || Content Library\>*</br>
- **vCenter FQDN or IP Address:** *\<Text Field for vCenter FQDN or IP Address\>*</br>
- **vCenter Connection:** *\<Drop Down list of vRO vCenter Endpoints\>*</br>
- **vCenter Username:** *\<Text Field for vCetner Username\>*</br>
- **vCenter Password:** *\<Secure String for vCenter User Password\>*</br>
- **If set to true, the certificate is accepted silently and the certificate is added to the trusted store:** *\<Boolean\>*</br>
- **OVA Path on VRO Appliance:** *\<Text Field for OVA Template Path\>*</br>
- **Content Library Template:** *\<Text Field for Content Library Template name\>*</br>
  



**[Back to top](#table-of-contents)**

# Execution

The flow of Actions for this workflow are:

1.  Retrieve vROClient for provided Controller.
2.  Retrieve Avi Cluster Configuration and validated if there is a failed node.
3.  Configure Cluster to Single Node using the Leader Node.
4.  Deploy Avi Appliances
	A. Create ovftool commands for the 3 appliances.
		i. Execute ovftool commands on Linux Server. All 3 are run simultaneously.
	B. Deploy Appliances using Content Library Template. THe Appliances are deployed and configured one at a time.
5.	Create base URL for controller validation.
6.	Import Certificate into vRO certificate store for the new Controller.
7.	Wait for Controllers to become ready. Run transient API calls against the “initial-data” API path. Wait for HTTP Response 200.
8.	Initiate Cluster Configuration
9.	Wait for Cluster to be ready.



**[Back to top](#table-of-contents)**

# Considerations

The following are considerations that need to be understood when executing this Workflow:

* This Workflow will only replace a single failed Node. If a cluster has multiple failed nodes, then the clsuter will need to be rebuilt using a Configuration Back.

**[Back to top](#table-of-contents)**

# Low-Level-Design

For a low level breakdown of the Workflow and the configured Actions, please see the attach “vRO - Cluster Node Remplacement” PDF file.

