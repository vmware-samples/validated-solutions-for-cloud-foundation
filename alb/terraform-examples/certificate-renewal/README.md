# Certificate Renewal

Developed by: William Stoneman  

## Table of Contents
1.	[Introduction](#Introduction)
1.	[Installation](#Installation)
1.	[Requirements](#Requirements)
1.	[Variable Input File](#Variable-Input-File)
1.	[Running](#Running)
1.	[Considerations](#Considerations)

# Introduction

The purpose of this Terraform Script is to provide the ability to replace Application or Controller certificates that were generated using the CSR method on the Avi Controller.

# Installation

The methods used within this Terraform configuration can be found in the Terriform Provider for Avi Networks (`vmware/avi`). The following software is required to successfully execute this Terraform configuration:

Terraform (tested on Terraform version 1.1.0 and up)

# Requirements

This Terraform configuration has been tested against renewing certificate objects for both application and controller certificates generated using the built in CSR process on the Avi Controller. 

* A CSR will need to be manaully created on the Avi Controller, and a certificate generated from a CA.

* The generated certificate file will need to be stored in the same directory as this Terraform Script.

**[Back to top](#table-of-contents)**

# Variable-Input-File

The following is a breakdown of the required Variables for this Terraform Script.

```hcl
avi_username.default = "<Avi Username>"
avi_controller.default = "<Avi Controller IP/FQDN>"
avi_password.default = <"Avi Password>"
avi_tenant.default = "<Avi Tenant>"
avi_version.default = "<Avi Version>"
cert_name.default = "<Avi Certificate Name>"
cert_file.default = "<Certificate file name (e.g. cert.csr)>"
```

**[Back to top](#table-of-contents)**

# Running

The flow of Actions for this Terraform configuration are:

1. Replace the Certificate element field of the specified certificate object.

If the certificate renewal failed, the Terraform configuration will fail, and the end user will need to validate the provided information.

**[Back to top](#table-of-contents)**

# Considerations

The following are considerations that need to be understood when executing this Terraform configuration:

* There is no way for the Terraform configuration to validate that the provided certificate text is valid for the selected Certificate Object. Therefore, we assume the end user has validated that the provided text is correct.

* We are relying on the positive response of the Certificate Object update, that the operation was successful. Therefore, we leave it up to the end user to validate the Controller accessibility.
