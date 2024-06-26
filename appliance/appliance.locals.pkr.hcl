# Copyright 2024 Broadcom. All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause

/*
    DESCRIPTION:
    VMware Photon OS 4 locals definition.
    Packer Plugin for VMware vSphere: 'vsphere-iso' builder.
*/

//  BLOCK: locals
//  Defines the local variables.

locals {
  vm_name           = var.appliance_artifact_name
  build_date        = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
  build_version     = var.appliance_version
  build_description = "${local.build_version}\n (${local.build_date})"
  ovf_export_path   = "${path.cwd}/artifacts/${local.vm_name}"
  data_source_content = {
    "/ks.json" = templatefile("${abspath(path.root)}/appliance.ks.pkrtpl.hcl", {
      build_username = var.build_username
      build_password = var.build_password
      root_password  = var.root_password
    })
  }
  data_source_command = var.data_source == "http" ? "ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ks.json" : "ks=/dev/sr1:/ks.json"
}
