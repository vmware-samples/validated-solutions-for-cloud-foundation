##################################################################################
# OUTPUTS
##################################################################################

output "vsphere_datacenter" {
    value = data.vsphere_datacenter.datacenter.name
}

output "vsphere_resource_pool" {
    value = data.vsphere_resource_pool.pool.name
}

output "vsphere_datastore" {
    value = data.vsphere_datastore.datastore.name
}

output "vsphere_folder" {
    value = vsphere_virtual_machine.vro_appliance.folder
}

output "vsphere_network" {
    value = data.vsphere_network.network.name
}

output "vro_appliance_name" {
    value = vsphere_virtual_machine.vro_appliance.name
}

output "vro_appliance_ip_address" {
	value = vsphere_virtual_machine.vro_appliance.vapp[0].properties.ip0
}