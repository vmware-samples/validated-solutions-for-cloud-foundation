##################################################################################
# PROVIDERS
##################################################################################

provider "restapi" {
  alias                = "csp"
  uri                  = var.csp_uri
  debug                = var.debug
  write_returns_object = true
  headers = {
    Content-Type = "application/x-www-form-urlencoded"
  }

  create_method = "POST"
}

provider "restapi" {
  alias                = "vmc"
  uri                  = var.vmc_uri
  debug                = var.debug
  write_returns_object = true

  headers = {
    csp-auth-token = restapi_object.retrieve_access_token.api_data.access_token
    Content-Type   = "application/json"
  }
}

##################################################################################
# DATA
##################################################################################



##################################################################################
# RESOURCES
##################################################################################

resource "restapi_object" "retrieve_access_token" {
  provider     = restapi.csp
  path         = "/csp/gateway/am/api/auth/api-tokens/authorize?refresh_token=${var.refresh_token}"
  data         = ""
  id_attribute = "expires_in"
}

