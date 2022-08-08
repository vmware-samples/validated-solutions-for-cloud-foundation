##################################################################################
# PROVIDERS
##################################################################################

provider "nsxt" {
  host                 = var.nsxt_instance
  username             = var.nsxt_username
  password             = var.nsxt_password
  allow_unverified_ssl = true
  max_retries          = 2
}

provider "restapi" {
  alias                 = "nsxt"
  uri                  = "https://${var.nsxt_instance}"
  username             = var.nsxt_username
  password             = var.nsxt_password
  write_returns_object = true
  insecure             = var.nsxt_insecure
}


##################################################################################
# DATA
##################################################################################


##################################################################################
# RESOURCES
##################################################################################

# Create VIDM User in NSX-T Manager
resource "restapi_object" "create_user" {
  provider      = restapi.nsxt
  path          = "/api/v1/aaa/role-bindings"
  create_method = "POST"
  data          = "{\"name\": \"${var.vidm_user}\",\"type\": \"${var.vidm_type}\",\"identity_source_type\": \"${var.vidm_identity_source}\",\"roles\": [{\"role\": \"${var.nsxt_role}\"}]}"
}
