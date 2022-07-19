##################################################################################
# VARIABLES
##################################################################################                                                 	                     

vra_url       = "https://api.mgmt.cloud.vmware.com"
vra_api_token = "********************"
vra_insecure  = false


##################################################################################
# PROJECT
##################################################################################

project_name                    = "Rainpole Sample"
project_description             = "Rainpole Sample Project"
project_operation_timeout       = 6000
project_machine_naming_template = "$${project.name}-$${resource.name}$${###}"
project_zone_priority           = 1
project_zone_max_instances      = 0
project_zone_cpu_limit          = 0
project_zone_memory_limit_mb    = 0
project_zone_storage_limit_gb   = 0
project_zones = {
  project_zone0 = {
    name = "sfo-w01-vc01.sfo.rainpole.io / sfo-w01-DC"
  }
}
project_administrator_roles = {
  role0 = {
    email = "user@vmware.com"
    type  = "user"
  }
}