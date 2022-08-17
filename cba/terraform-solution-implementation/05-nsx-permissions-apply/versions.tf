##################################################################################
# VERSIONS
##################################################################################

terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.2.8"
    }
    restapi = {
      source  = "Mastercard/restapi"
      version = "1.17.0"
    }
  }
  required_version = ">= 1.2.0"
}
