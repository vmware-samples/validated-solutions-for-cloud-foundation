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

variable "catalog_sources" {
  type = map(object({
    name         = string
    description  = string
    project_name = string
  }))
}
