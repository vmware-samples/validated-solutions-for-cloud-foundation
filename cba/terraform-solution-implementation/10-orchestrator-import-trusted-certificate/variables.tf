##################################################################################
# VARIABLES
##################################################################################

variable "csp_api_token" {
  type        = string
  description = "API token from the vRealize Automation endpoint."
}

variable "cep_server" {
  type        = string
  description = "The FQDN of the Cloud Extensibility Proxy."
}