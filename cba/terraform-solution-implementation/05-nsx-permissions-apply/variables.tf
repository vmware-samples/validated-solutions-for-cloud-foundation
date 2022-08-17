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

variable "vidm_user" {
  type        = string
  description = "The user/group the role needs to be assignd to. (e.g. svc-vmc-nsx@sfo.rainpole.io)"
}

variable "vidm_type" {
  type        = string
  description = "The type of account. (e.g. remote_user or remote_group)"
}

variable "vidm_identity_source" {
  type        = string
  description = "The Identity Source for user/group. (e.g. LDAP, VIDM or OIDC)"
}

variable "nsxt_role" {
  type = string
}