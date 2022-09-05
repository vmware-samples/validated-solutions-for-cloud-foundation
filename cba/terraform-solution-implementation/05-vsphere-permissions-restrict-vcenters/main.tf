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

data "vsphere_folder" "folder" {
  path = var.folder_path
}

data "vsphere_role" "role_name" {
  label = var.role_name
}

##################################################################################
# RESOURCES
##################################################################################


resource "vsphere_entity_permissions" "vcenter-ca-user" {
  entity_id   = data.vsphere_folder.folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.ca_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.role_name.id
  }
}

resource "vsphere_entity_permissions" "vcenter-vro-user" {
  entity_id   = data.vsphere_folder.folder.id
  entity_type = "Folder"
  permissions {
    user_or_group = var.vro_service_account
    propagate     = true
    is_group      = false
    role_id       = data.vsphere_role.role_name.id
  }
}
