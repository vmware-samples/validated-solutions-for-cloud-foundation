##################################################################################
# VERSIONS
##################################################################################

terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.3.1"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.1.1"
    }
    terracurl = {
      source  = "devops-rob/terracurl"
      version = "0.1.1"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.8.0"
    }
    vra = {
      source  = "vmware/vra"
      version = ">= 0.7.2"
    }
  }
  required_version = ">= 1.2.0"
}