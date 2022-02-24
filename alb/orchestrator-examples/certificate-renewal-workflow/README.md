# Certificate Renewal

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

The purpose of this workflow is to provide the ability to replace Application or Controller certificates that were generated using the CSR method on the Avi Controller.

# Installation

This Workflow and the Actions composed inside of it, will be included in the next release of the Avi Networks vRO Plugin. The plugin can be downloaded from the Avi Networks Github Repository “avi-vrealize-orchestrator-plugin” at https://github.com/avinetworks/avi-vrealize-orchestrator-plugin.

# Requirements

This Workflow has been tested against renewing certificate Objects for both Application and Controller certificates generated using the built in CSR process on the Avi Controller.

It is assumed that the specified Controller has already been added to vRO as a vROClient Object.


**[Back to top](#table-of-contents)**

# Configuration

This Workflow does not require any specific configuration to successfully execute.


**[Back to top](#table-of-contents)**


# Input-Form

The following is a breakdown of the Input Form for this Workflow.

### General: 
- **Controller:** *\<Drop Down list of vro Clients\>*</br>
- **Certificate Name:** *\<Drop Down list of certificates\>*</br>
- **New Certificate File:** *\<Text input for certificate file\>*</br>


**[Back to top](#table-of-contents)**

# Execution

The flow of Actions for this workflow are:

1.	Retrieve vROClient Object for the specified Controller.
2.	Replace the Certificate element field of the specified certificate Object.

If the certificate renewal failed, the Workflow will fail, and the end user will need to validate the provided information.


**[Back to top](#table-of-contents)**

# Considerations

The following are considerations that need to be understood when executing this Workflow:

* There is no way for the workflow to validate that the provided certificate text is valid for the selected Certificate Object. Therefore, we assume the end user has validated that the provided text is correct.

* We are relying on the positive response of the Certificate Object update, that the operation was successful. There is not a way for the workflow to validate that the certificate change was successful, unless we attempt to do a curl API call as described in the Cluster Upgrade Workflow. Therefore, we leave it up to the end user to validate the Controller accessibility.

**[Back to top](#table-of-contents)**

# Low-Level-Design

For a low level breakdown of the Workflow and the configured Actions, please see the attach “vRO - Certificate Renewal” PDF file.

