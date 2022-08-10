##################################################################################
# VARIABLES
##################################################################################

# vSphere Settings

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  sensitive   = true
}
variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance."
  sensitive   = true
}
variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}
variable "vsphere_insecure" {
  type        = bool
  description = "Allow insecure connections. Set to `true` for self-signed certificates."
  default     = false
}

variable "vsphere_host" {
  type        = string
  description = "The fully qualified domain name or IP address of the initial ESXi host."
}
variable "vsphere_datacenter" {
  type        = string
  description = "The target vSphere datacenter object name. "
}
variable "vsphere_datastore" {
  type        = string
  description = "The target vSphere datastore object name."
}
variable "vsphere_cluster" {
  type        = string
  description = "The target vSphere cluster object name."
}
variable "vsphere_network" {
  type        = string
  description = "The target vSphere network object name."
}
variable "vsphere_folder" {
  type        = string
  description = "The target vSphere folder object name."
}

# vRealize Orchestrator Settings

variable "vro_ovf_local" {
  type        = string
  description = "The local path to the vRealize Orchestrator OVA file. Leave blank if using remote."
  default     = null
}
variable "vro_root_password" {
  type        = string
  description = "The password for the root user account."
  sensitive   = true
}
variable "vro_name" {
  type        = string
  description = "The name for the virtual appliance in the vSphere inventory."
}
variable "vro_ntp_servers" {
  type        = string
  description = "The NTP server fully qualified domain names or IP addresses (comma separated) for time synchronization."
}
variable "vro_fips_mode" {
  type        = string
  description = "Enable FIPS Mode for the virtual appliance. One of `disabled` or `enabled`."
  default     = "disabled"
}
variable "vro_ip_address" {
  type        = string
  description = "The IP address for the network interface on the virtual appliance. Leave blank if DHCP is desired."
}
variable "vro_netmask" {
  type        = string
  description = "The netmask or prefix for the network interface on the virtual appliance. Leave blank if DHCP is desired."
}
variable "vro_gateway" {
  type        = string
  description = "The default gateway address for the virtual appliance. Leave blank if DHCP is desired."
}
variable "vro_dns_servers" {
  type        = string
  description = "The DNS server IP addresses (comma separated) for name resolution. Leave blank if DHCP is desired."
}
variable "vro_domain" {
  type        = string
  description = "The domain name for the virtual appliance. Leave blank if DHCP is desired."
}
variable "vro_dns_search" {
  type        = string
  description = "The domain search path (comma or space separated domain names) for the virtual appliance. Leave blank if DHCP is desired."
}
variable "vro_disk_provisioning" {
  type        = string
  description = "The disk provisioning option for the virtual appliance."
  default     = "thin"
}
variable "vro_k8s_cluster_cidr" {
  type        = string
  description = "The internal CIDR for pods running in the K8s cluster."
  default     = "10.244.0.0/22"
}
variable "vro_k8s_service_cidr" {
  type        = string
  description = "The internal CIDR for services running in the K8s cluster."
  default     = "10.244.4.0/22"
}