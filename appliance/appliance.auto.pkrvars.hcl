# Copyright 2024 Broadcom. All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause

/*
    DESCRIPTION:
    VMware Photon OS 4 build variables.
    Packer Plugin for VMware vSphere: 'vsphere-iso' builder.
*/

vsphere_endpoint            = "sfo-m01-vc01.rainpole.io"
vsphere_username            = "administrator@vsphere.local"
vsphere_password            = "VMware1!"
vsphere_insecure_connection = true
vsphere_datacenter          = "sfo-m01-dc01"
vsphere_cluster             = "sfo-m01-cl01"
vsphere_datastore           = "sfo-m01-cl01-vsan"
vsphere_network             = "DHCP"
vsphere_folder              = "templates"
vm_guest_os_type            = "vmwarePhoton64Guest"
vm_version                  = 19
vm_cdrom_type               = "sata"
vm_cdrom_count              = 1
vm_cpu_count                = 2
vm_cpu_cores                = 1
vm_mem_size                 = 2048
vm_disk_size                = 40960
iso_url                     = "https://packages.vmware.com/photon/4.0/Rev2/iso/photon-4.0-c001795b8.iso"
iso_checksum_value          = "eeb08738209bf77306268d63b834fd91f6cecdfb"
iso_checksum_type           = "sha1"
