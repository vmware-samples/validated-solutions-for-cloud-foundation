# Copyright 2024 Broadcom. All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause

/*
    DESCRIPTION:
    VMware Photon OS 4 build definition.
    Packer Plugin for VMware vSphere: 'vsphere-iso' builder.
*/

//  BLOCK: source
//  Defines the builder configuration blocks.

source "vsphere-iso" "appliance" {
  vcenter_server       = var.vsphere_endpoint
  username             = var.vsphere_username
  password             = var.vsphere_password
  insecure_connection  = var.vsphere_insecure_connection
  datacenter           = var.vsphere_datacenter
  cluster              = var.vsphere_cluster
  datastore            = var.vsphere_datastore
  folder               = var.vsphere_folder
  vm_name              = local.vm_name
  guest_os_type        = var.vm_guest_os_type
  firmware             = var.vm_firmware
  CPUs                 = var.vm_cpu_count
  cpu_cores            = var.vm_cpu_cores
  CPU_hot_plug         = var.vm_cpu_hot_add
  RAM                  = var.vm_mem_size
  RAM_hot_plug         = var.vm_mem_hot_add
  cdrom_type           = var.vm_cdrom_type
  disk_controller_type = var.vm_disk_controller_type
  storage {
    disk_size             = var.vm_disk_size
    disk_thin_provisioned = var.vm_disk_thin_provisioned
  }
  network_adapters {
    network      = var.vsphere_network
    network_card = var.vm_network_card
  }
  vm_version           = var.vm_version
  remove_cdrom         = var.vm_remove_cdrom
  reattach_cdroms      = var.vm_cdrom_count
  tools_upgrade_policy = var.vm_tools_upgrade_policy
  notes                = local.build_description
  iso_url              = var.iso_url
  iso_checksum         = "${var.iso_checksum_type}:${var.iso_checksum_value}"
  http_content         = var.data_source == "http" ? local.data_source_content : null
  cd_content           = var.data_source == "disk" ? local.data_source_content : null
  http_ip              = var.http_ip
  http_port_min        = var.http_port_min
  http_port_max        = var.http_port_max
  boot_order           = var.vm_boot_order
  boot_wait            = var.vm_boot_wait
  boot_command = [
    "<esc><wait>c",
    "linux /isolinux/vmlinuz root=/dev/ram0 loglevel=3 insecure_installation=1 ${local.data_source_command} photon.media=cdrom",
    "<enter>",
    "initrd /isolinux/initrd.img",
    "<enter>",
    "boot",
    "<enter>"
  ]
  ip_wait_timeout   = var.ip_wait_timeout
  ip_settle_timeout = var.ip_settle_timeout
  shutdown_command  = "echo '${var.build_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout  = var.shutdown_timeout
  communicator      = var.communicator_protocol
  ssh_port          = var.communicator_port
  ssh_timeout       = var.communicator_timeout
  ssh_username      = var.build_username
  ssh_password      = var.build_password
  export {
    name             = local.vm_name
    output_directory = local.ovf_export_path
    force            = var.ovf_export_overwrite
    options          = ["extraconfig"]
  }
}

//  BLOCK: build
//  Defines the builders to run, provisioners, and post-processors.

build {
  sources = ["source.vsphere-iso.appliance"]

  provisioner "file" {
    destination = "/tmp/appliance.json"
    source      = "appliance.json"
  }

  provisioner "file" {
    destination = "/tmp/"
    source      = "files/"
}

  provisioner "shell" {
    inline = [
      "sudo mkdir /root/setup",
      "sudo mkdir /root/config",
      "sudo mv /tmp/appliance.json /root/config/appliance.json",
      "sudo mv /tmp/rc.local /etc/rc.d/rc.local",
      "sudo mv /tmp/getOvfProperty.py /root/setup/getOvfProperty.py",
      "sudo mv /tmp/setup.sh /root/setup/setup.sh",
      "sudo mv /tmp/setup-01-os.sh /root/setup/setup-01-os.sh",
      "sudo mv /tmp/setup-02-network.sh /root/setup/setup-02-network.sh",
      "sudo mv /tmp/setup-03-banner.sh /root/setup/setup-03-banner.sh"
    ]
  }

  provisioner "shell" {
    expect_disconnect = true
    scripts           = ["scripts/appliance-settings.sh"]
  }

  provisioner "shell" {
    pause_before = "20s"
    scripts      = ["scripts/appliance-cleanup.sh"]
  }

  post-processors {
    post-processor "shell-local" {
      environment_vars = ["APPLIANCE_VERSION=${var.appliance_version}", "APPLIANCE_NAME=${local.vm_name}", "FINAL_APPLIANCE_NAME=${local.vm_name}-${var.appliance_version}", "APPLIANCE_OVF_TEMPLATE=${var.ovf_template}"]
      inline           = ["cd scripts/", "./appliance-properties.sh"]
    }

    post-processor "shell-local" {
      inline = ["pwsh -F scripts/appliance-unregister.ps1 ${var.vsphere_endpoint} ${var.vsphere_username} ${var.vsphere_password} ${local.vm_name}"]
    }
  }
}
