##################################################################################
# VERSIONS
##################################################################################

terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.2.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.1"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "0.1.0"
    }
  }
  required_version = ">= 1.2.0"
}