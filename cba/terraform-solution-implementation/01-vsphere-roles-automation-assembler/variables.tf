##################################################################################
# VARIABLES
##################################################################################

# vSphere Credentials

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-w01-vc01.sfo.rainpole.io)"
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
  description = "Set to true for self-signed certificates."
  default     = false
}

# Roles

variable "assembler_vsphere_role" {
  type        = string
  description = "The name for the VMware Aria Automation Assembler to vSphere Integration custom role. (e.g. VMware Aria Automation Assembler to vSphere Integration)"
  default     = "VMware Aria Automation Assembler to vSphere Integration"
}

variable "orchestrator_vsphere_role" {
  type        = string
  description = "The name for the VMware Aria Automation Orchestrator to vSphere Integration custom role. (e.g. VMware Aria Automation to vSphere Integration)"
  default     = "VMware Aria Automation to vSphere Integration"
}

variable "assembler_vsphere_privileges" {
  type        = list(string)
  description = "The vSphere permissions for the VMware Aria Automation Assembler to vSphere Integration custom role."
}

variable "orchestrator_vsphere_privileges" {
  type        = list(string)
  description = "The vSphere permissions for the VMware Aria Automation to vSphere Integration custom role."
}
