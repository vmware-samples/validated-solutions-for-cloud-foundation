##################################################################################
# VERSIONS
##################################################################################

terraform {
  required_providers {
    vra = {
      source  = "vmware/vra"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.0.0"
    }
  }
  required_version = ">= 0.5.1"
}