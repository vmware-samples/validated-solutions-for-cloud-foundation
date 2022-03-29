# NSX-T Cloud Data Segment Addition

Developed by: William Stoneman  

## Table of Contents
1.	[Introduction](#Introduction)
1.	[Installation](#Installation)
1.	[Requirements](#Requirements)
1.	[Variable Input File](#Variable-Input-File)
1.	[Running](#Running)
1.	[Considerations](#Considerations)

# Introduction

The Purpose of of these Terraform configurations is to configure the intial Data Segment or add additional Data Segments to an exisiting NSX-T Cloud configured on an Avi Cluster. When an NSX-T Cloud Connector is created through the Avi UI, it is required to configure atleast 1 Data Segment. However, when configuring an NSX-T Cloud through Terraform you can configure the Cloud without this requirement. This is useful if seperate teams handle the individual parts of the Cloud.

As this process updates an existing Cloud Connector Object and Terraform is not aware of the Object, we are required to first pull the Cloud Connector Object, update the Data Segment Contents and re Apply the configuration. The process will be outlined below.

# Installation

The methods used within this Terraform configuration can be found in the Terraform Provider for Avi Networks (`vmware/avi`). The following software is required to successfully execute this Terraform configuration.

- Terraform (tested on Terraform version 1.1.0 and up)

# Requirements

The following prerequisites are required to successfully utilize this Workflow:

* An operational NSX-T Cloud Connector configured on an Avi Cluster.

**[Back to top](#table-of-contents)**

# Variable-Input-File

The following is a breakdown of the required Variables for this Terraform script.

```hcl
avi_controller.default = "<Controller Cluster/Node IP>"
avi_username.default = "<Avi Username>"
avi_password.default = "<Avi User Password>"
avi_version.default = "<Avi Controller Version (e.g. 20.1.6)>"
data_lr_id.default = "<T1 Router Name>"
data_segment_id.default = "<Data Segment Name>"
```

**[Back to top](#table-of-contents)**

# Running

The following are a high level overview of the steps required to complete the Data Segment creation. For a more indepth walkthrough, please follow the steps outlined in the "Create Initial Data Segment" and "Create Subsequent Data Segments" pages.

The flow of actions to create the initial data segment:

1.	Create a `main.tf` Terraform configuration to retrieve NSX-T Cloud Connector `uuid`.
2.	Create a `variables.tf` file.
3.	Run `terraform init` | `terraform plan`, and copy the uuid from the output.
4.  Append the Terraform configuration to retrieve Cloud Connector Object.
5.  Run `terraform import avi_cloud.nsx-t-cloud <cloud uuid copied in step 4>`.
6.  Run `terraform show` and copy the output.
7.  Edit the configuration's `avi_cloud` section and add the output from step 6.
8.  Edit the `data_network_config` section of the `avi_cloud` resource, and add the new data segment configuration.
9.  Run `terraform plan` | `terraform apply`.

The flow of actions to create a subsequent data segment:

1.	Create a `main.tf` Terraform configuration retrieve NSXT Cloud Connector UUID.
2.	reate a `variables.tf` file.
3.	Run "=`terraform init`` | `terraform plan`, and copy the uuid from the output.
4.  Append the Terraform configuration to retrieve Cloud Connector Object.
5.  Run `terraform import avi_cloud.nsx-t-cloud <cloud uuid copied in step 4>`.
6.  Run `terraform show` and copy the output.
7.  Edit the configuration's `avi_cloud` section and add the output from step 6.
8.  Edit the `data_network_config` section of the `avi_cloud` resource, and append the new data segment configuration to the end of the section.
9.  Run `terraform plan` | `terraform apply`.

**[Back to top](#table-of-contents)**

# Considerations

The following are considerations that need to be understood when executing this configuration:

* This configuration requires you to first pull the current NSX-T Cloud Object from the Avi Controllers, and manually update the object to be pushed back.
