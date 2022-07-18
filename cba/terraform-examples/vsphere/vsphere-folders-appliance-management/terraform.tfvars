##################################################################################
# VARIABLES
##################################################################################

# Credentials

vsphere_server   = "sfo-m01-vc01.sfo.rainpole.io"
vsphere_username = "administrator@vsphere.local"
vsphere_password = "VMw@re1!"
vsphere_insecure = false

# vSphere Settings

vsphere_datacenter = "sfo-m01-dc01"

# Folders

vsphere_folders = {
  folder0 = {
    path = "sfo-m01-fd-vmc"
    type = "vm"
  }
}