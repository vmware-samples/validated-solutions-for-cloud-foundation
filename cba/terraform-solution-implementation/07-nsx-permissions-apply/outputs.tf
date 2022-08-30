##################################################################################
# OUTPUTS
##################################################################################

output "output_nsx_response" {
  value = jsondecode(terracurl_request.nsx_create_user.response)
}

output "output_nsx_user_id" {
  value = jsondecode(terracurl_request.nsx_create_user.response).id
}
