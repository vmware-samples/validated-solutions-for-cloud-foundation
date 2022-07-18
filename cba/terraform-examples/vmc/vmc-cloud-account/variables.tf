##################################################################################
# VARIABLES
##################################################################################

variable "csp_uri" {
  type        = string
  description = "Base URL for VMware Cloud Service API endpoint"
  default     = "https://console-stg.cloud.vmware.com/"
}

variable "vmc_uri" {
  type        = string
  description = "Base URL for VMware Cloud Console API endpoint"
  default     = "https://vmc.vmware.com"
}

variable "debug" {
  type        = bool
  description = "Enable debugging"
}

variable "refresh_token" {
  type        = string
  description = "VMware Cloud Service Refresh Token"
  sensitive   = true
}

variable "org_id" {
  type        = string
  description = "VMware Cloud on AWS Organization ID"
  sensitive   = true
}

variable "sddc_id" {
  type        = string
  description = "VMware Cloud on AWS SDDC ID"
  sensitive   = true
}