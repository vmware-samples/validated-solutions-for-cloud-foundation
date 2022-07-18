##################################################################################
# PROVIDERS
##################################################################################

provider "vsphere" {
  vsphere_server       = var.vsphere_server
  user                 = var.vsphere_username
  password             = var.vsphere_password
  allow_unverified_ssl = var.vsphere_insecure
}

##################################################################################
# DATA
##################################################################################

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_folder" "folder" {
  path = var.folder_path
  }
  
data "vsphere_role" "vmc-vsphere" {
  label = var.vmc_vsphere_role
}

data "vsphere_role" "vro-vsphere" {
  label = var.vro_vsphere_role
}


##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_entity_permissions" "vcenter" {
  entity_id   = data.vsphere_folder.folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.vmc_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.vmc-vsphere.id
  }
}