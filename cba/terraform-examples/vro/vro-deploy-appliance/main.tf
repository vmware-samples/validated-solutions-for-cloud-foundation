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

data "vsphere_resource_pool" "pool" {
  name          = format("%s%s", var.vsphere_cluster, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_ovf_vm_template" "ovf" {
  name             = var.vro_name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  host_system_id   = data.vsphere_host.host.id
  local_ovf_path   = var.vro_ovf_local
  ovf_network_map = {
    "Network 1" : data.vsphere_network.network.id
  }
}

##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_virtual_machine" "vro_appliance" {
  name                 = var.vro_name
  folder               = var.vsphere_folder
  resource_pool_id     = data.vsphere_resource_pool.pool.id
  datastore_id         = data.vsphere_datastore.datastore.id
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  host_system_id       = data.vsphere_host.host.id
  num_cpus             = data.vsphere_ovf_vm_template.ovf.num_cpus
  num_cores_per_socket = data.vsphere_ovf_vm_template.ovf.num_cores_per_socket
  memory               = data.vsphere_ovf_vm_template.ovf.memory
  guest_id             = data.vsphere_ovf_vm_template.ovf.guest_id
  dynamic "network_interface" {
    for_each = data.vsphere_ovf_vm_template.ovf.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }
  
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  
  ovf_deploy {
    local_ovf_path    = var.vro_ovf_local
    disk_provisioning = var.vro_disk_provisioning
    ovf_network_map   = data.vsphere_ovf_vm_template.ovf.ovf_network_map
  }
  
  vapp {
    properties = {
      "vami.hostname"                 = var.vro_name
      "varoot-password"               = var.vro_root_password
      "ntp-servers"                   = var.vro_ntp_servers
      "va-ssh-enabled"                = "False"
      "va-run-deploy"                 = "True"
      "k8s-cluster-cidr"              = var.vro_k8s_cluster_cidr
      "k8s-service-cidr"              = var.vro_k8s_service_cidr
      "fips-mode"                     = var.vro_fips_mode
      "ip0"                          	= var.vro_ip_address
      "netmask0"                     	= var.vro_netmask
      "gateway"                      	= var.vro_gateway
      "DNS"                          	= var.vro_dns_servers
      "domain"                       	= var.vro_domain
      "searchpath"                   	= var.vro_dns_search
    }
  }
  
  lifecycle { 
    ignore_changes = [ # Items to be ignored when re-applying a plan
      sync_time_with_host_periodically, # Don't set time source to null
      host_system_id # Don't move the VM back to the host it was deployed to
    ]
  }
}
