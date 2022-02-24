# Password Change

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

The purpose of this workflow is to allow the end user to change the password for ANY AVI User, NSX-T Cloud connector Credential Object or vCenter Cloud connectory Credential Object. The Workflow, allows you to specify if you want to update an Avi user password or an NSX-T Cloud Connector, or both.


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
- **Controller:** *\<Drop Down list of vro Clients\>*</br>
- **Change AVI User Password?:** *\<boolean\>*</br>
- **Change NSX-T Connector Password?:** *\<boolean\>*</br> 

### AVI User Password Change: 
- **Avi User:** *\<Drop Down list of users\>*</br> 
- **Old Password:** *\<SecureString Password Field\>*</br> 
- **New Password:** *\<SecureString Password Field\>*</br> 
- **Verify New Password:** *\<Constraint - Must match New Password\>*</br> 

### NSX-T Password Change: 
- **NSX-T Cloud:** *\<Drop Down list of clouds\>*</br> 
- **New NSX-T Connector Password:** *\<SecureString Password Field\>*</br> 
- **Verify New NSX-T Connector Password:** *\<Constraint - Must match New Password\>*</br> 


**[Back to top](#table-of-contents)**

# Execution

The flow of Actions for this workflow are:

1.	Retrieve vROClient for provided Controller.
2.	Decision – Change NSX-T Cloud Connector password?
a.	Yes – Change NSX-T Cloud Connector password based on provided information.
b.	No – Continue with Workflow.
3.	Decision – Change Avi User password?
a.	Yes – Change Avi User password based on previded information.
b.	No – End Workflow. 


If the NSX-T Cloud Connector password change failed, the Workflow will fail, and the end user will need to validate the provided information.

If the Avi User password change failed, the Workflow will fail, and the end user will need to validate the provided information.

**[Back to top](#table-of-contents)**

# Considerations

The following are considerations that need to be understood when executing this Workflow:

* In the Input form you have the ability to populate drop down lists of Objects based on the configuration of the selected Controller. In this case, the list of Cloud Connectors. However, there is no way to limit the retrieved selection to a specific Cloud type using the built in method. This can be resolved by creating a custom method to retrieve in this case only the NSX-T Cloud Connectors, and we are actively working on this as of July 2021.


* We are relying on the positive response of the password change, that the operation was successful. In the case of the Avi user, there is not a way to validate the password change was successful, unless we attempt to do a curl API call as described in the Cluster Upgrade Workflow. Therefore, we leave it up to the end user to validate the user account is still accessible.

* For the NSX-T Cloud Connector change, we again rely on the positive response of the password change, that the operation was successful. By changing the Credential Object, the Controller does not validate that the credentials are correct. Therefore, we assume the end user is updating the Object with the correct password.

**[Back to top](#table-of-contents)**

# Low-Level-Design

For a low level breakdown of the Workflow and the configured Actions, please see the attach “vRO - Password Change” PDF file.

