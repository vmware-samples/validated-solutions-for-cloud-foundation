##################################################################################
# VARIABLES
##################################################################################

# Credentials

variable "vcf_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the VMware Cloud Foundation instance. (e.g. sfo-vcf01.sfo.rainpole.io)"
}

variable "vcf_username" {
  type        = string
  description = "The username to login to the VMware Cloud Foundation instance."
}

variable "vcf_password" {
  type        = string
  description = "The password for the login to the VMware Cloud Foundation instance."
}

# vSphere Objects

variable "vcf_domain" {
  type        = string
  description = "The Workload Domain within the VMware Cloud Foundation instance. (e.g. sfo-m01)"
}

variable "vro_service_account" {
  type        = string
  description = "The target VMC Service account to assign the role to. (e.g. svc-vro-vsphere@sfo)"
}

# Active Directory

variable "domain_fqdn" {
  type        = string
  description = "The FQDN of the Active Directory domain. (e.g. sfo.rainpole.io)"
}

variable "domain_bind_username" {
  type        = string
  description = "The bind user to login to Active Directory."
}

variable "domain_bind_password" {
  type        = string
  description = "The password for the bind user to login to Active Directory."
}
