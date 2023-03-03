# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/*
    DESCRIPTION:
    The variable definitions for the VMware Photon OS appliance build.
*/

variable "appliance_version" {
  type        = string
  description = "The version of the appliance."
  default     = null
}

variable "esxi_host_type" {
  type        = string
  description = "The ESXi host type for the Packer build."
  default     = "esx5"
}

variable "esxi_host_endpoint" {
  type        = string
  description = "The target ESXi host FQDN or IP address."
}

variable "esxi_host_username" {
  type        = string
  description = "The ESXi host username."
  default     = "root"
}

variable "esxi_host_password" {
  type        = string
  description = "The ESXi host password."
}

variable "esxi_host_portgroup" {
  type        = string
  description = "The target portgroup for the build."
}

variable "esxi_host_datastore" {
  type        = string
  description = "The target datastore for the build."
}

variable "esxi_host_insecure" {
  type        = bool
  description = "Enable insecure mode for ESXi host."
  default     = true
}

variable "esxi_host_vnc_over_websocket" {
  type        = bool
  description = "Enable VNC over WebSocket for ESXi host."
  default     = true
}

variable "os_packagelist" {
  type        = string
  description = "The VMware Photon OS installation package."
  default     = "minimal"
  validation {
    condition     = contains(["minimal", "developer"], var.os_packagelist)
    error_message = "Must be one of 'minimal' or 'developer'."
  }
}

variable "vm_name" {
  type        = string
  description = "The name of the virtual machine for the build."
  default     = "photon"
}

variable "iso_url" {
  type        = string
  description = "The URL to the VMware Photon OS installation ISO."
}

variable "iso_checksum_type" {
  type        = string
  description = "The checksum type for the VMware Photon OS installation ISO."
  default     = "sha1"
  validation {
    condition     = contains(["sha1", "md5"], var.iso_checksum_type)
    error_message = "Must be one of 'sha1' or 'md5'."
  }
}

variable "iso_checksum_value" {
  type        = string
  description = "The checksum value for the VMware Photon OS installation ISO."
}

variable "boot_wait" {
  type        = string
  description = "The time to wait for the virtual machine to boot."
  default     = "10s"
}

variable "boot_key_interval" {
  type        = string
  description = "The time to wait between keystrokes."
  default     = "10ms"
}

variable "boot_command" {
  type        = list(string)
  description = "The boot command for the guest OS."
  default = [
    "<esc><wait>",
    "vmlinuz initrd=initrd.img root=/dev/ram0 loglevel=3 ks=/dev/sr1:/ks.json insecure_installation=1 photon.media=cdrom",
    "<enter>"
  ]
}

variable "ssh_timeout" {
  type        = string
  description = "The time to wait for SSH to become available."
  default     = "15m"
}

variable "ssh_username" {
  type        = string
  description = "The SSH username for the guest OS."
  default     = "root"
}

variable "ssh_password" {
  type        = string
  description = "The SSH password for the guest OS."
  default     = "VMw@re123!"
  sensitive   = true
}

variable "ssh_port" {
  type        = number
  description = "The SSH port for the guest OS."
  default     = 22
}

variable "shutdown_timeout" {
  type        = string
  description = "The time to wait for the virtual machine to shutdown."
  default     = "1000s"
}

variable "headless" {
  type        = bool
  description = "Enable headless mode for the virtual machine."
  default     = false
}

variable "skip_compaction" {
  type        = bool
  description = "Skip compaction of the virtual machine disk."
  default     = true
}

variable "format" {
  type        = string
  description = "The format of the virtual machine."
  default     = "ovf"
}

variable "hardware_version" {
  type        = number
  description = "The hardware version for the virtual machine."
  default     = 19
  validation {
    condition = (
      var.hardware_version >= 13 &&
      var.hardware_version <= 20
    )
    error_message = "Must be between 13 and 20."
  }
}

variable "guest_os" {
  type        = string
  description = "The guest OS type for the virtual machine."
  default     = "vmware-photon-64"
}

variable "cpu_count" {
  type        = number
  description = "The number of virtual CPUs for the virtual machine."
  default     = 2
}

variable "memory_size" {
  type        = number
  description = "The amount of memory for the virtual machine."
  default     = 8192
}

variable "disk_adapter" {
  type        = string
  description = "The disk adapter type for the virtual machine."
  default     = "pvscsi"
}

variable "disk_size" {
  type        = number
  description = "The size of the virtual machine disk."
  default     = 20480
}

variable "network_adapter" {
  type        = string
  description = "The network adapter type for the virtual machine."
  default     = "vmxnet3"
}

variable "ovftool_deploy_vcenter_endpoint" {
  type        = string
  description = "The vCenter Server FQDN or IP address."
  default     = null
}

variable "ovftool_deploy_vcenter_username" {
  type        = string
  description = "The vCenter Server username."
  default     = null
}

variable "ovftool_deploy_vcenter_password" {
  type        = string
  description = "The vCenter Server password."
  default     = null
}

variable "ovf_template" {
  type        = string
  description = "The OVF template for the virtual machine."
  default     = "photon.xml.template"
}
