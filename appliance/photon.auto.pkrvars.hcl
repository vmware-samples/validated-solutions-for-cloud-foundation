# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

/*
    DESCRIPTION:
    The Packer variable settings for the VMware Photon OS appliance.w
*/

// ESXi Host Settings

esxi_host_endpoint  = "m01-esx01.rainpole.io"
esxi_host_username  = "root"
esxi_host_password  = "VMware1!"
esxi_host_datastore = "local-ssd-01"
esxi_host_portgroup = "DHCP"

// vCenter Server Settings

ovftool_deploy_vcenter_endpoint = "m01-vc01.rainpole.io"
ovftool_deploy_vcenter_username = "administrator@vsphere.local"
ovftool_deploy_vcenter_password = "VMware1!"

// Virtual Machine Settings

vm_name            = "appliance"
iso_url            = "https://packages.vmware.com/photon/4.0/Rev2/iso/photon-4.0-c001795b8.iso"
iso_checksum_type  = "md5"
iso_checksum_value = "5af288017d0d1198dd6bd02ad40120eb"
cpu_count          = "2"
memory_size        = "8192"
ssh_username       = "root"
ssh_password       = "VMw@re123!"
