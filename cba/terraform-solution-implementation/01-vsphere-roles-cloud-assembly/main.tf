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


##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_role" "ca-vsphere" {
  name            = var.ca_vsphere_role
  role_privileges = var.ca_vsphere_privileges
}

resource "vsphere_role" "vro-vsphere" {
  name            = var.vro_vsphere_role
  role_privileges = var.vro_vsphere_privileges
}


