##################################################################################
# VERSIONS
##################################################################################

terraform {
  required_providers {
    vra = {
      source  = "vmware/vra"
      version = ">= 0.7.2"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.3.1"
    }
  }
    required_version = ">= 1.2.0"
}