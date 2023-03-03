# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/*
    DESCRIPTION:
    The Packer template for building the VMware Photon OS appliance.
*/

//  BLOCK: packer
//  The Packer configuration.

packer {
  required_version = ">= 1.8.6"
  required_plugins {
    vmware = {
      version = ">= v1.0.7"
      source  = "github.com/hashicorp/vmware"
    }
  }
}

//  BLOCK: locals
//  Defines the local variables.

locals {
  build_date    = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version = var.appliance_version
  annotation    = "Build Version: ${local.build_version}\nBuild Date: ${local.build_date}"
}

//  BLOCK: source
//  Defines the builder configuration blocks.

source "vmware-iso" "appliance" {
  remote_type          = var.esxi_host_type
  remote_host          = var.esxi_host_endpoint
  remote_username      = var.esxi_host_username
  remote_password      = var.esxi_host_password
  remote_datastore     = var.esxi_host_datastore
  insecure_connection  = var.esxi_host_insecure
  vnc_over_websocket   = var.esxi_host_vnc_over_websocket
  vm_name              = var.vm_name
  format               = var.format
  version              = var.hardware_version
  guest_os_type        = var.guest_os
  cpus                 = var.cpu_count
  memory               = var.memory_size
  network_adapter_type = var.network_adapter
  network_name         = var.esxi_host_portgroup
  disk_adapter_type    = var.disk_adapter
  disk_size            = var.disk_size
  headless             = var.headless
  cd_content = {
    "/ks.json" = templatefile("${abspath(path.root)}/photon.pkrtpl.hcl", {
      os_packagelist = var.os_packagelist
      ssh_username   = var.ssh_username
      ssh_password   = var.ssh_password
    })
  }
  iso_url           = var.iso_url
  iso_checksum      = "${var.iso_checksum_type}:${var.iso_checksum_value}"
  boot_wait         = var.boot_wait
  boot_command      = var.boot_command
  boot_key_interval = var.boot_key_interval
  ssh_username      = var.ssh_username
  ssh_password      = var.ssh_password
  ssh_port          = var.ssh_port
  ssh_wait_timeout  = var.ssh_timeout
  shutdown_command  = "echo '${var.ssh_password}' | sudo -S -E shutdown -P now"
  shutdown_timeout  = var.shutdown_timeout
  skip_compaction   = var.skip_compaction
  vmx_data_post = {
    "annotation" = local.annotation
  }
}

//  BLOCK: build
//  Defines the builders to run, provisioners, and post-processors.

build {
  sources = ["source.vmware-iso.appliance"]

  provisioner "shell" {
    inline = ["mkdir -p /root/config"]
  }

  provisioner "file" {
    destination = "/root/config/appliance-bom.json"
    source      = "appliance-bom.json"
  }

  provisioner "shell" {
    expect_disconnect = true
    scripts           = ["scripts/photon-settings.sh"]
  }

  provisioner "shell" {
    pause_before = "20s"
    scripts      = ["scripts/photon-cleanup.sh"]
  }

  provisioner "file" {
    destination = "/etc/rc.d/rc.local"
    source      = "files/rc.local"
  }

  provisioner "file" {
    destination = "/root/setup/getOvfProperty.py"
    source      = "files/getOvfProperty.py"
  }

  provisioner "file" {
    destination = "/root/setup/setup.sh"
    source      = "files/setup.sh"
  }

  provisioner "file" {
    destination = "/root/setup/setup-01-os.sh"
    source      = "files/setup-01-os.sh"
  }

  provisioner "file" {
    destination = "/root/setup/setup-02-network.sh"
    source      = "files/setup-02-network.sh"
  }

  provisioner "file" {
    destination      = "/root/setup/setup-099-banner.sh"
    source           = "files/setup-099-banner.sh"
  }

  post-processors {

    post-processor "shell-local" {
        environment_vars = ["APPLIANCE_VERSION=${var.appliance_version}", "APPLIANCE_NAME=${var.vm_name}", "FINAL_APPLIANCE_NAME=${var.vm_name}_${var.appliance_version}", "APPLIANCE_OVF_TEMPLATE=${var.ovf_template}"]
        inline           = ["cd manual", "./add_ovf_properties.sh"]
    }

    post-processor "shell-local" {
      inline = ["pwsh -F appliance-unregister.ps1 ${var.ovftool_deploy_vcenter_endpoint} ${var.ovftool_deploy_vcenter_username} ${var.ovftool_deploy_vcenter_password} ${var.vm_name}"]
    }

  }
}
