##################################################################################
# VARIABLES
##################################################################################

# VMware Cloud Foundation Credentials

variable "vcf_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the SDDC Manager instance. (e.g. sfo-vcf01.sfo.rainpole.io)"
}

variable "vcf_username" {
  type        = string
  description = "The username to login to the SDDC Manager instance. (e.g. administrator@vsphere.local)"
  default     = "administrator@vsphere.local"
}

variable "vcf_password" {
  type        = string
  description = "The password for the login to the SDDC Manager instance."
}

# vSphere Objects

variable "assembler_vsphere_role" {
  type        = string
  description = "The name for the VMware Aria Automation Assembler to vSphere Integration custom role. (e.g. VMware Aria Automation Assembler to vSphere Integration)"
  default     = "VMware Aria Automation Assembler to vSphere Integration"
}

variable "assembler_service_account" {
  type        = string
  description = "The target VMware Aria Automation Assembler Service account to assign the role to. (e.g. svc-vaa-vsphere@sfo)"
}

variable "orchestrator_vsphere_role" {
  type        = string
  description = "The name for the VMware Aria Automation Orchestrator to vSphere Integration custom role. (e.g. VMware Aria Automation to vSphere Integration)"
  default     = "VMware Aria Automation to vSphere Integration"
}

variable "orchestrator_service_account" {
  type        = string
  description = "The target VMware Aria Automation Orchestrator Service account to assign the role to. (e.g. svc-vao-vsphere@sfo)"
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
