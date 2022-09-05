##################################################################################
# OUTPUTS
##################################################################################

output "ca_vsphere_role" {
    value = vsphere_role.ca_vsphere.name
}

output "vro_vsphere_role" {
    value = vsphere_role.vro_vsphere.name
}