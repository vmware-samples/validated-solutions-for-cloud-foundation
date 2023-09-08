##################################################################################
# VARIABLES
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

variable "project_name" {
  type        = string
  description = "The name of the project."
}

variable "project_description" {
  type        = string
  description = "The description for the project."
}

variable "project_operation_timeout" {
  type        = number
  description = "A operations timeout period assigned to the project."
  default     = 600
}

variable "project_machine_naming_template" {
  type        = string
  description = "A naming template for each zone assigned to the project."
}

variable "project_zone_priority" {
  type        = number
  description = "A priority for each zone assigned to the project."
  default     = 1
}

variable "project_zone_max_instances" {
  type        = number
  description = "A maximum instances for each zone assigned to the project."
  default     = 0
}

variable "project_zone_cpu_limit" {
  type        = number
  description = "A CPU limit for each zone assigned to the project."
  default     = 0
}

variable "project_zone_memory_limit_mb" {
  type        = number
  description = "A memory limit in MB for each zone assigned to the project."
  default     = 0
}

variable "project_zone_storage_limit_gb" {
  type        = number
  description = "A storage limit in GB for each zone assigned to the project."
  default     = 0
}

variable "project_zones" {
  type        = map(any)
  description = "A mapping of cloud zone names to assign to the project."
}

variable "project_administrator_roles" {
  type        = map(any)
  description = "A list of users/groups to assign to project administators."
}

variable "project_member_roles" {
  type        = map(any)
  description = "A list of users/groups to assign to project members."
}

variable "project_viewer_roles" {
  type        = map(any)
  description = "A list of users/groups to assign to project viewers."
}

