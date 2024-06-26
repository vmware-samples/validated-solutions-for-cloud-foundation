# Copyright 2024 Broadcom. All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause

/*
    DESCRIPTION:
    VMware Photon OS 4 build variables.
    Packer Plugin for VMware vSphere: 'vsphere-iso' builder.
*/

//  BLOCK: variable
//  Defines the input variables.

// Appliance Settings

variable "appliance_name" {
  type        = string
  description = "The name of the appliance."
}

variable "appliance_artifact_name" {
  type        = string
  description = "The name of the appliance artifact."
}

variable "appliance_version" {
  type        = string
  description = "The semantic version of the appliance."
  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+$", var.appliance_version))
    error_message = "The appliance version must be in the form of x.y.z where x, y, and z are integers."
  }
}

variable "root_password" {
  type        = string
  description = "The root password to login to the guest operating system."
  sensitive   = true
}

variable "build_username" {
  type        = string
  description = "The username to login to the guest operating system."
  default     = "admin"
}

variable "build_password" {
  type        = string
  description = "The password to login to the guest operating system."
  sensitive   = true
}

// vSphere Credentials

variable "vsphere_endpoint" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
}

variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}

variable "vsphere_insecure_connection" {
  type        = bool
  description = "Do not validate vCenter Server TLS certificate."
  default     = false
}

// vSphere Settings

variable "vsphere_datacenter" {
  type        = string
  description = "The name of the target vSphere datacenter."
}

variable "vsphere_cluster" {
  type        = string
  description = "The name of the target vSphere cluster."
}

variable "vsphere_datastore" {
  type        = string
  description = "The name of the target vSphere datastore."
}

variable "vsphere_network" {
  type        = string
  description = "The name of the target vSphere network segment."
}

variable "vsphere_folder" {
  type        = string
  description = "The name of the target vSphere folder."
}

// Virtual Machine Settings

variable "vm_guest_os_type" {
  type        = string
  description = "The guest operating system type, also know as guestid."
}

variable "vm_firmware" {
  type        = string
  description = "The virtual machine firmware."
  default     = "efi-secure"
  validation {
    condition     = contains(["bios", "efi", "efi-secure"], var.vm_firmware)
    error_message = "Must be one of: bios, efi, efi-secure."
  }
}

variable "vm_cdrom_type" {
  type        = string
  description = "The virtual machine CD-ROM type."
  default     = "sata"
}

variable "vm_cdrom_count" {
  type        = string
  description = "The number of virtual CD-ROMs remaining after the build."
  default     = 1
}

variable "vm_cpu_count" {
  type        = number
  description = "The number of virtual CPUs."
}

variable "vm_cpu_cores" {
  type        = number
  description = "The number of virtual CPUs cores per socket."
}

variable "vm_cpu_hot_add" {
  type        = bool
  description = "Enable hot add CPU."
  default     = false
}

variable "vm_mem_size" {
  type        = number
  description = "The size for the virtual memory in MB."
}

variable "vm_mem_hot_add" {
  type        = bool
  description = "Enable hot add memory."
  default     = false
}

variable "vm_disk_size" {
  type        = number
  description = "The size for the virtual disk in MB."
}

variable "vm_disk_controller_type" {
  type        = list(string)
  description = "The virtual disk controller types in sequence."
  default     = ["pvscsi"]
}

variable "vm_disk_thin_provisioned" {
  type        = bool
  description = "Thin provision the virtual disk."
  default     = true
}

variable "vm_network_card" {
  type        = string
  description = "The virtual network card type."
  default     = "vmxnet3"
}

variable "vm_version" {
  type        = number
  description = "The vSphere virtual hardware version."
  default     = 19
}

variable "vm_tools_upgrade_policy" {
  type        = bool
  description = "Upgrade VMware Tools on reboot."
  default     = true
}

variable "vm_remove_cdrom" {
  type        = bool
  description = "Remove the virtual CD-ROM(s)."
  default     = true
}

// OVF Export Settings

variable "ovf_export_overwrite" {
  type        = bool
  description = "Overwrite existing OVF artifact."
  default     = true
}

// Removable Media Settings

variable "iso_url" {
  type        = string
  description = "The URL to download the guest operating system ISO."
}

variable "iso_checksum_type" {
  type        = string
  description = "The checksum algorithm used for the guest operating system ISO."
  default     = "sha512"
  validation {
    condition     = contains(["sha1", "sha256", "sha512"], var.iso_checksum_type)
    error_message = "Must be one of: sha1, sha256, sha512."
  }
}

variable "iso_checksum_value" {
  type        = string
  description = "The checksum value for the guest operating system ISO."
}

// Boot Settings

variable "data_source" {
  type        = string
  description = "The provisioning data source."
  default     = "disk"
  validation {
    condition     = contains(["disk", "http"], var.data_source)
    error_message = "Must be one of: disk, http."
  }
}

variable "http_ip" {
  type        = string
  description = "Define an IP address on the host to use for the HTTP server."
  default     = null
}

variable "http_port_min" {
  type        = number
  description = "The start of the HTTP port range."
  default     = 8000
}

variable "http_port_max" {
  type        = number
  description = "The end of the HTTP port range."
  default     = 8099
}

variable "vm_boot_order" {
  type        = string
  description = "The boot order for virtual machines devices."
  default     = "disk,cdrom"
}

variable "vm_boot_wait" {
  type        = string
  description = "The time to wait before boot."
  default     = "2s"
}

variable "ip_wait_timeout" {
  type        = string
  description = "Time to wait for guest operating system IP address response."
  default     = "20m"
}

variable "ip_settle_timeout" {
  type        = string
  description = "Time to wait for guest operating system IP to settle down."
  default     = "5s"
}

variable "shutdown_timeout" {
  type        = string
  description = "Time to wait for guest operating system shutdown."
  default     = "15m"
}

// Communicator Settings

variable "communicator_protocol" {
  type        = string
  description = "The communicator protocol."
  default     = "ssh"
  validation {
    condition     = contains(["ssh", "winrm"], var.communicator_protocol)
    error_message = "Must be one of: ssh, winrm."
  }
}

variable "communicator_port" {
  type        = string
  description = "The port for the communicator protocol."
  default     = 22
}

variable "communicator_timeout" {
  type        = string
  description = "The timeout for the communicator protocol."
  default     = "30m"
}

variable "ovf_template" {
  type        = string
  description = "The OVF template for the virtual machine."
  default     = "appliance.xml.template"
}
