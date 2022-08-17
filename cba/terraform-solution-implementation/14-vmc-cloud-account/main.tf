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

data "vra_data_collector" "dc" {
  count = var.cloud_proxy != "" ? 1 : 0
  name  = var.cloud_proxy
}

// Cloud Assembly

data "vra_cloud_account_vsphere" "this" {
  depends_on = [vra_cloud_account_vsphere.this]
  for_each   = var.cloud_accounts_vsphere
  name       = each.value.name
}

data "vra_region" "this" {
  depends_on       = [vra_cloud_account_vsphere.this]
  for_each         = var.cloud_accounts_vsphere
  cloud_account_id = data.vra_cloud_account_vsphere.this[each.key].id
  region           = each.value.region
}

data "vra_region_enumeration_vsphere" "this" {
  for_each                = var.cloud_accounts_vsphere
  username                = each.value["username"]
  password                = each.value["password"]
  hostname                = each.value["hostname"]
  dcid                    = var.cloud_proxy != "" ? data.vra_data_collector.dc[0].id : ""
  accept_self_signed_cert = var.accept_self_signed
}

##################################################################################
# RESOURCES
##################################################################################

// Cloud Assembly

# Create the Cloud Accounts for Cloud Foundation in Cloud Assembly.

resource "vra_cloud_account_vsphere" "this" {
  for_each                     = var.cloud_accounts_vsphere
  name                         = each.value["name"]
  description                  = each.value["description"]
  username                     = each.value["username"]
  password                     = each.value["password"]
  hostname                     = each.value["hostname"]
  dcid                         = var.cloud_proxy != "" ? data.vra_data_collector.dc[0].id : ""
  regions                      = data.vra_region_enumeration_vsphere.this[each.key].regions
  associated_cloud_account_ids = [vra_cloud_account_nsxt.this[each.key].id]
  accept_self_signed_cert      = var.accept_self_signed
  tags {
    key   = "cloud"
    value = each.value["tag_cloud"]
  }
}

resource "vra_cloud_account_nsxt" "this" {
  for_each                = var.cloud_accounts_nsx
  name                    = each.value["name"]
  description             = each.value["description"]
  username                = each.value["username"]
  password                = each.value["password"]
  hostname                = each.value["hostname"]
  dc_id                   = var.cloud_proxy != "" ? data.vra_data_collector.dc[0].id : ""
  accept_self_signed_cert = var.accept_self_signed
  tags {
    key   = "cloud"
    value = each.value["tag_cloud"]
  }
}

# Create the Cloud Zones for Cloud Foundation in Cloud Assembly.

resource "vra_zone" "this" {
  for_each    = var.cloud_accounts_vsphere
  name        = each.value["name"]
  description = each.value["description"]
  region_id   = data.vra_region.this[each.key].id
  tags {
    key   = "region"
    value = each.value["tag_region"]
  }
}