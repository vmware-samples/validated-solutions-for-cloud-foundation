##################################################################################
# OUTPUTS
##################################################################################

output "vm_host_group_ruleset" {
	value = resource.vsphere_compute_cluster_vm_host_rule.vm_host_group_ruleset.name
}

output "affinity_host_group_name" {
	value = var.vsphere_host_group
}

output "vmc_group_name" {
	value = resource.vsphere_compute_cluster_vm_group.vmc_group_name.name
}