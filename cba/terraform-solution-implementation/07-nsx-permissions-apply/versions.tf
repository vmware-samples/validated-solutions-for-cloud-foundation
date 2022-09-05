##################################################################################
# VERSIONS
##################################################################################

terraform {
  required_providers {
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "0.1.1"
    }
  }
  required_version = ">= 1.2.0"
}