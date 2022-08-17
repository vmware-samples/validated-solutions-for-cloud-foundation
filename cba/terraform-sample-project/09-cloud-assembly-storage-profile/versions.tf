##################################################################################
# VERSIONS
##################################################################################

terraform {
  required_providers {
    vra = {
      source  = "vmware/vra"
      version = ">= 0.5.3"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.2.0"
    }
  }
    required_version = ">= 1.2.0"
}