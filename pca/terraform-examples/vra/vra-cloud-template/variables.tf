##################################################################################
# VARAIBLES
##################################################################################

# Endpoints

variable "vra_url" {
  type        = string
  description = "The base URL of the Aria Automation endpoint. (e.g. https://xint-vra01.rainpole.io)"
}

variable "vra_api_token" {
  type        = string
  description = "API token from the Aria Automation endpoint."
  sensitive   = true
}

variable "vra_insecure" {
  type        = bool
  description = "Set to true for self-signed certificates."
  default     = false
}

# Aria Automation Assembler

variable "cloud_templates" {
  type = map(object({
    name                = string
    description         = string
    project_name        = string
    content             = string
    release_changelog   = string
    release_description = string
    release_version     = string
    release_status      = bool
  }))
}
