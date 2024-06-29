# Copyright 2024 Broadcom. All rights reserved.
# SPDX-License-Identifier: BSD-2-Clause

/*
    DESCRIPTION:
    VMware Photon OS 4 versions definition.
    Packer Plugin for VMware vSphere: 'vsphere-iso' builder.
*/

//  BLOCK: packer
//  The Packer configuration.

packer {
  required_version = ">= 1.11.0"
  required_plugins {
    vsphere = {
      source  = "github.com/hashicorp/vsphere"
      version = ">= 1.3.0"
    }
  }
}
