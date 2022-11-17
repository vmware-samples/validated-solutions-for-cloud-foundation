##################################################################################
# VARIABLES
##################################################################################

# VMware Cloud Services (CSP) API Endpoint

variable "csp_uri" {
  type        = string
  description = "Base URL for VMware Cloud Service API endpoint"
  default     = "https://console.cloud.vmware.com"
}

variable "vrops_uri" {
  type        = string
  description = "Base URL for VMware vRealize Operations Cloud API Endpoint"
  default     = "https://api.mgmt.cloud.vmware.com"
}

variable "csp_api_token" {
  type        = string
  description = "VMware Cloud Service Refresh Token"
  sensitive   = true
}

# vSphere Settings

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
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

# VCF Settings

variable "vcf_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the SDDC Manager instance."
}

variable "vcf_username" {
  type        = string
  description = "The username to login to the SDDC Manager instance. (e.g. administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}

variable "vcf_password" {
  type        = string
  description = "The password for the login to the SDDC Manager instance."
  sensitive   = true
}

# NSX Settings

variable "nsx_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the NSX Manager instance."
}

variable "nsx_username" {
  type        = string
  description = "The username to login to the NSX Manager instance. (e.g. admin)"
  default     = "admin"
}

variable "nsx_password" {
  type        = string
  description = "The password for the login to the NSX Manager instance."
  sensitive   = true
}

#vRealize Operations Cloud Settings

variable "vrops_cloud_collector_group_name" {
  type = string
  default = "sitea"
}