##################################################################################
# PROVIDERS
##################################################################################


##################################################################################
# DATA
##################################################################################


##################################################################################
# RESOURCES
##################################################################################

resource "null_resource" "vro_service_account" {
  provisioner "local-exec" {
    command     = "Add-SsoPermission -server \"${var.vcf_server}\" -user \"${var.vcf_username}\" -pass \"${var.vcf_password}\" -sddcDomain \"${var.vcf_domain}\" -domain \"${var.domain_fqdn}\" -domainBindUser \"${var.domain_bind_username}\" -domainBindPass \"${var.domain_bind_password}\" -principal \"${var.vro_service_account}\" -ssoGroup \"Administrators\" -type user -source external"
    interpreter = ["PowerShell", "-Command"]
  }
}
