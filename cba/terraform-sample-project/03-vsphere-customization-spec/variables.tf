##################################################################################
# VARIABLES
##################################################################################

# vCenter Server Endpoint

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance. (e.g. sfo-m01-vc01.sfo.rainpole.io)"
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance."
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
}

variable "customization_name" {
  type = string
}

variable "customization_description" {
  type = string
}

variable "customization_type" {
  type = string
}

variable "customization_domain" {
  type = string
}

variable "customization_timezone" {
  type = string
}
