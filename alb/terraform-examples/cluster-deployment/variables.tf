vsphere_user.default = *\<vSphere Username\>*

vsphere_password.default = *\<vSphere Password\>*

vsphere_server.default = *\vSphere Server IP/FQDN\>*

datacenter_name.default = *\<Datacenter Name\>*

cluster_name.default = *\<Cluster Name\>*

datastore_name.default = *\<Datastore Name\>*

dvs_name.default = *\<DVS Name\>*

mgmt_net_name.default = *\<Management Network Port Group Name\>*

Controller_vm_name.default = *\<Avi Controller VM Name List (Ex. ["avi-tf-01", "avi-tf-02","avi-tf-03"]\>*

vsphere_resource_pool.default = *\<Resource Pool Name\>*

vm_folder.default = *\<Folder Name\>*

avi_username.default = *\<Avi Username\>*

avi_new_password.default = *\<NEW Avi Admin Password\>*

avi_version.default = *\<Avi Controller Version (Ex. "20.1.8")\>*

avi_ctrl_mgmt_ips.default = *\<Avi Controller Management Network IP Addresse List (Ex. ["10.10.10.10", "10.10.10.11","10.10.10.12"]) \>* 

subnetMask.default = *\<Management Network Subnet Mask\>*

defaultGateway.default = *\<Management Network Default Gateway\>*

clustervip.default = *\<Cluster VIP IP Address\>*

backup_passphrase.default = *\<Backup Passphrase\>*

system_dnsresolvers.default = *\<DNS Server IP Addresses List (Ex. ["8.8.8.8", "8.8.4.4"]) \>*

system_ntpservers.default = *\<NTP Server List (Ex. ["0.us.pool.ntp.org", "1.us.pool.ntp.org"]) \>*








variable "vsphere_user" {
  type = string
  default = <vSphere Username>
}
variable "vsphere_password" {
  type = string
  default = <vSphere Password>
}
variable "vsphere_server" {
  type = string
  default = <vSphere IP/FQDN>
}
variable "datacenter_name" {
  type = string
  default = <Datacenter Name>
}
variable "cluster_name" {
  type = string
  default = <Cluster Name>
}
variable "datastore_name" {
  type = string
  default = <Datastore Name>
}
variable "dvs_name" {
  type = string
  default = <DVS Name>
}
variable "mgmt_net_name" {
  type = string
  default = <Management Network Portgroup Name>
}
variable "local_ovf_path" {
  type = string
  default = ""
}
variable "vsphere_resource_pool" {
  type = string
  default = <Resource Pool Name>
}
variable "vm_folder" {
  type = string
  default = <Folder Name>
}
variable "avi_username" {
  type = string
  default = <Avi Username>
}
variable "avi_new_password" {
  type = string
  default = <Avi Admin NEW Password>
}
variable "avi_version" {
  type = string
  default = <Avi Controller Version>
}

variable "clustervip" {
  type = string
  default = <Avi Cluster VIP IP>
}
variable "backup_passphrase" {
  type = string
  default = <Avi Backup Passphrase>
}
variable "system_dnsresolvers" {
  type = list
  default = <DNS Server IP Addresses List (Ex. ["8.8.8.8", "8.8.4.4"])>
}
variable "system_ntpservers" {
  type    = list
  default = <NTP Server List (Ex. ["0.us.pool.ntp.org", "1.us.pool.ntp.org"])>
}
variable "avi_ctrl_mgmt_ips" {
  type    = list
  default = <Avi Controller Management Network IP Addresse List (Ex. ["10.10.10.10", "10.10.10.11","10.10.10.12"])>
}
variable "subnetMask" {
  type = string
  default = <Management Network Subnet Mask>
}
variable "defaultGateway" {
  type = string
  default = <Management Network Default Gateway>
}
variable "Controller_vm_name" {
  type    = list
  default = <Avi Controller VM Name List (Ex. ["avi-tf-01", "avi-tf-02","avi-tf-03"]>
}


