##################################################################################
# VARIABLES
##################################################################################

# VCF Credentials

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

variable "vcf_domain" {
  type        = string
  description = "The Workload Domain of the VMware Cloud Foundation instance."
}

variable "csp_api_token" {
  type        = string
  description = "API token from the vRealize Automation endpoint."
}

variable "cep_server" {
  type        = string
  description = "The FQDN of the Cloud Extensibility Proxy."
}

variable "vro_service_account" {
  type        = string
  description = "The target vRealize Orchestrator Service account. (e.g. svc-vro-vsphere@sfo.rainpole.io)"
}

variable "vro_service_password" {
  type        = string
  description = "The targetvRealize Orchestrator Service account password."
}