##################################################################################
# VARIABLES
##################################################################################

# Endpoints

variable "vra_url" {
  type        = string
  description = "The base URL of the vRealize Automation endpoint. (e.g. https://api.mgmt.cloud.vmware.com)"
  default     = "https://api.mgmt.cloud.vmware.com"
}

variable "vra_api_token" {
  type        = string
  description = "API token from the vRealize Automation endpoint."
  sensitive   = true
}

variable "vra_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates."
  default     = false
}

# Cloud Assembly

variable "cloud_zone_name" {
  type        = string
  description = "The name of the Cloud Zone (e.g. sfo-w01-vc01)"
}

variable "workload_target_folder" {
  type        = string
  description = "The name of the folder within the Cloud Zone to provision virtual machines too (e.g. sfo-w01-fd-workload)"
}

variable "fabric_compute_name" {
  type        = string
  description = "The name of the resource pool within the Cloud Zone to provision virtual machines too (e.g. sfo-w01-cl01 / sfo-w01-cl01-rp-workload)"
}

variable "tag_zone" {
  type        = string
  description = "The the zone tag for the Cloud Zone. (e.g. sfo-w01)"
}
