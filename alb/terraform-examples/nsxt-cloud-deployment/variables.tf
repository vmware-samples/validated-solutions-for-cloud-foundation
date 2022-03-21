variable "avi_username" {
  type    = string
  default = <Avi Username>
}

variable "avi_controller" {
  type    = string
  default = <Controller Cluster/Node IP>
}
variable "avi_password" {
  type    = string
  default = <Avi User Password>
}

variable "avi_tenant" {
  type    = string
  default = "admin"
}

variable "avi_version" {
  type    = string
  default = <Avi Controller Version>
}

variable "nsxt_url" {
  type    = string
  default = <NSXT Manager FQDN/IP Address>
}

variable "nsxt_avi_user" {
  type    = string
  default = <NSXT Cloud Connector User Object Name>
}

variable "nsxt_username" {
  type    = string
  default = <NSXT Username>
}

variable "nsxt_password" {
  type    = string
  default = <NSXT Password>
}

variable "vsphere_server" {
  type    = string
  default = <vCenter Server FQDN/IP Address>
}

variable "vcenter_avi_user" {
  type    = string
  default = <vCenter Cloud Connector User Object Name>
}

variable "vsphere_user" {
  type    = string
  default = <vCenter Username>
}

variable "vsphere_password" {
  type    = string
  default = <vCenter Password>
}

variable "nsxt_cloudname" {
  type    = string
  default = <NSXT CLoud Connector Name>
}

variable "nsxt_cloud_prefix" {
  type    = string
  default = <NSXT Object Name Prefix>
}

variable "transport_zone_name" {
  type    = string
  default = <Transport Zone Name>
}

variable "mgmt_lr_id" {
  type    = string
  default = <MGMT T1 Name>
}

variable "mgmt_segment_id" {
  type    = string
  default = <MGMT Segment Name>
}

variable "data_lr_id" {
  type    = string
  default = <Data T1 Name>
}

variable "data_segment_id" {
  type    = string
  default = <Data Segment Name>
}

variable "vcenter_id" {
  type    = string
  default = <vCenter Connection Object Name>
}

variable "content_library_name" {
  type    = string
  default = <Content Library Name>
}

