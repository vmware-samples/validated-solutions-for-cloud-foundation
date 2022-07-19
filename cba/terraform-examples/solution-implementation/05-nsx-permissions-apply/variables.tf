##################################################################################
# VARIABLES
##################################################################################

variable "nsxt_instance" {
  type        = string
  description = "The fully qualified domain name or IP address of the NSX Manager instance. (e.g. sfo-w01-nsx01.sfo.rainpole.io)"
}

variable "nsxt_username" {
  type        = string
  description = "The username to login to the vCenter Server instance. (e.g. admin)"
  default     = "admin"
}

variable "nsxt_password" {
  type        = string
  description = "The password for the login to the NSX Manager instance."
}

variable "nsxt_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates."
  default     = false
}

variable "nsxt_uri" {
  type        = string
  description = "Base URL for NSX Manager Endpoint"
}

variable "debug" {
  type        = bool
  description = "Enable debugging"
}
