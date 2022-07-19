####################################
# NSX-T Session Token
####################################

provider "restapi" {
  alias                = "nsxt_session_token"
  uri                  = var.nsxt_uri
  debug                = var.debug
  write_returns_object = true

  headers = {
    Content-Type = "application/x-ww-form-urlencoded"
  }

  create_method = "POST"
}

# Retreive NSX-T Session Token
resource "restapi_object" "session_token" {
  provider     = restapi.nsxt_session_token
  path         = "/api/session/create"
  data         = "{\"j_username\": \"${var.nsxt_username}\",\"j_password\": \"${var.nsxt_password}\"}"
}

##################################################################################
# DATA
##################################################################################



##################################################################################
# RESOURCES
##################################################################################

