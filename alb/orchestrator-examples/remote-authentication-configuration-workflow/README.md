# Remote Authentication

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

The purpose of this workflow is to allow the end user to configure remote user authentication configuration. This Workflow allows for LDAP and SAML Authentication Configuration.


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
- **Remote Authentication Type:** *\<Drop Down list of Auth Types - SAML || LDAP\>*</br>
- **Authentication Profile Name:** *\<Text Field for Authentication Profile Object Name\>*</br>
- **Type of SAML Endpoint:** *\<Drop Down list of SAML Endpoint Types - Cluster || DNS || User\>*</br>
- **Metadata:** *\<Text Field for SAML Metadata\>*</br>
- **Org Name:** *\<Text Field for SAML Org Name\>*</br>
- **Org Display Name:** *\<Text Field for SAML Org Display Name\>*</br>
- **Org URL:** *\<Text Field for SAML Org URL\>*</br>
- **Technical Contact Name:** *\<Text Field for SAML Technical Contact Name\>*</br>
- **Technical Contact Email:** *\<Text Field for SAML Technical Contact Email\>*</br>
- **Fully Qualified Domain Name:** *\<Text Field for SAML Fully Qualified Domain Name\>*</br>
- **LDAP Port:** *\<Text Field for LDAP Port\>*</br>
- **Secure LDAP using TLS:** *\<Drop Down For TSL Option - YES || NO\>*</br>
- **ldapServers:** *\<Data Grid for Array of LDAP IP addresses or FQDN\>*</br>
- **Base DN:** *\<Text Field for LDAP Base DN\>*</br>
- **Admin Bind DN:** *\<Text Field for LDAP Admin Bind DN\>*</br>
- **Admin Bind Password:** *\<Secure String for LDAP Admin Bind Password\>*</br>
- **User Search DN:** *\<Text Field for LDAP User Search DN\>*</br>
- **Group Search DN:** *\<Text Field for LDAP Group Search DN\>*</br>
- **User ID Attribute:** *\<Text Field for LDAP User ID Attribute\>*</br>
- **User Search Scope:** *\<Text Field for LDAP User Search Scope\>*</br>
- **Group Search Scope:** *\<Text Field for LDAP Group Search Scope\>*</br>
- **Group Member Attribute:** *\<Text Field for LDAP Group Member Attribute\>*</br>
- **Group Filter:** *\<Text Field for LDAP Group Filter\>*</br>
- **Group member entries contain full DNs instead of just user id attribute values:** *\<Boolean\>*</br>
- **During user or group search, ignore searching referrals:** *\<Boolean\>*</br>



**[Back to top](#table-of-contents)**

# Execution

The flow of Actions for this workflow are:

1.	Retrieve vROClient for provided Controller.
2.	Build Auth Profile based on Auth Type and Provided Configuration Parameters.
3.  Retrieve System Configuration Object and Update the Auth Profile.


**[Back to top](#table-of-contents)**

# Considerations

The following are considerations that need to be understood when executing this Workflow:

* This Workflow creates and sets the Auth Profile for the Avi Cluster, however the end user will need to to create the Authentication Group mapping.

**[Back to top](#table-of-contents)**

# Low-Level-Design

For a low level breakdown of the Workflow and the configured Actions, please see the attach “vRO - Remote Authentication Configuration” PDF file.

