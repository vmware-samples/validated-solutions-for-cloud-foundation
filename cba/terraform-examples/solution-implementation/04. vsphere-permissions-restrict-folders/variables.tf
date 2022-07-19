##################################################################################
# VARIABLES
##################################################################################

# Credentials

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-m01-vc01.sfo.rainpole.io)"
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
  description = "Set to true for self-signed certificates."
  default     = false
}

# vSphere Objects

variable "vsphere_datacenter" {
  type        = string
  description = "The target vSphere datacenter object name. (e.g. sfo-m01-dc01)"
}

variable "edge_folder" {
  type        = string
  description = "The target folder where permissions are assigned. (e.g. sfo-w01-fd-edge)"
}

variable "local_storage_folder" {
  type        = string
  description = "The target folder where permissions are assigned. (e.g. sfo-w01-fd-storage-local)"
}

variable "readonly_storage_folder" {
  type        = string
  description = "The target folder where permissions are assigned. (e.g. sfo-w01-fd-storage-readonly)"
}

variable "vmc_service_account" {
  type        = string
  description = "The target VMC Service account to assign the role to. (e.g. svc-vmc-vsphere@sfo)"
}

variable "vro_service_account" {
  type        = string
  description = "The target VMC Service account to assign the role to. (e.g. svc-vro-vsphere@sfo)"
}

variable "role_name" {
  type        = string
  description = "The target role name to be assigned. (e.g. No access)"
}