##################################################################################
# PROVIDERS
##################################################################################

provider "vra" {
  url                         = var.vra_url
  refresh_token               = var.vra_api_token
  insecure                    = var.vra_insecure
}

##################################################################################
# DATA
##################################################################################

data "vra_zone" "cloud_zone_name" {
  name  = var.cloud_zone_name
}

data "vra_fabric_compute" "compute_id" {
  filter = "name eq '${var.fabric_compute_name}'"
}

##################################################################################
# RESOURCES
##################################################################################


resource "vra_fabric_compute" "resource_pool" {
  tags {
    key   = "enabled"
    value = "true"
  }
}

resource "vra_zone" "cloud_zone_update" {
  name  	= var.cloud_zone_name
  folder 	= var.workload_target_folder
  region_id	= data.vra_zone.cloud_zone_name.external_region_id
  tags_to_match {
    key                       = "enabled"
    value                     = "true"
  }

  lifecycle { 
  ignore_changes = [ # Items to be ignored when re-applying a plan
    region_id,
    description
    ]
  }
}
