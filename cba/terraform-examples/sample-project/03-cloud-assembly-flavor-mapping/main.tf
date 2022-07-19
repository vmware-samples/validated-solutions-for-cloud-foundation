##################################################################################
# PROVIDERS
##################################################################################

provider "vra" {
  url           = var.vra_url
  refresh_token = var.vra_api_token
  insecure      = var.vra_insecure
}

##################################################################################
# DATA
##################################################################################

// CLOUD ASSEMBLY

data "vra_cloud_account_vsphere" "cloud-account" {
  name = var.cloud_account_vsphere
}


##################################################################################
# RESOURCES
##################################################################################

// CLOUD ASSEMBLY

# Create the flavor mappings in Cloud Assembly for a vCenter Server cloud account.

resource "vra_flavor_profile" "this" {
  name      = var.cloud_account_vsphere
  region_id	= data.vra_cloud_account_vsphere.cloud-account.id
  dynamic "flavor_mapping" {
    for_each = { for flavor in var.flavor_mappings : flavor.name => flavor }
    content {
      name      = flavor_mapping.value["name"]
      cpu_count = flavor_mapping.value["cpu_count"]
      memory    = flavor_mapping.value["memory"]
    }
  }
}