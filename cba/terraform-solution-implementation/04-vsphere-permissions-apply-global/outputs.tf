##################################################################################
# OUTPUTS
##################################################################################

output "ca_role" {
  value = var.ca_vsphere_role
}

output "ca_account" {
  value = var.ca_service_account
}

output "vro_role" {
  value = var.vro_vsphere_role
}

output "vro_account" {
  value = var.vro_service_account
}