#!/bin/bash -eux
# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Apply the appliance settings. ###
echo '> Applying the appliance settings...'
BOM_FILE=/root/config/appliance-bom.json

### Disable IPv6. ###
echo '> Disabling IPv6...'
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf

### Apply the latest operating system updates. ###
echo '> Applying latest operating system updates...'
cd /etc/yum.repos.d/
sed -i 's/dl.bintray.com\/vmware/packages.vmware.com\/photon\/$releasever/g' photon.repo photon-updates.repo photon-extras.repo photon-debuginfo.repo
tdnf -y update photon-repos
tdnf -y remove docker
tdnf clean all
tdnf makecache
tdnf -y update

### Install additional packages. ###
echo '> Installing additional packages...'
tdnf install -y \
  minimal \
  logrotate \
  wget \
  git \
  unzip \
  tar \
  jq \
  cronie \
  powershell \
  python3-pip

### Install Python packages. ###
echo -e "\e[92mInstalling Python packages..."
MASKPASS_VERSION=$(jq -r < ${BOM_FILE} '.["maskpass"].version' | sed 's/v//g')
ln -s /usr/bin/pip3 /usr/bin/pip
pip install requests
pip install setuptools
pip install paramiko
pip install maskpass==${MASKPASS_VERSION}
    
### Create a directory for setup scripts and configuration files. ###
echo '> Creating a directory for setup scripts and configuration files...' 
mkdir -p /root/setup

### Create an /etc/vmware-tools/tools.conf to prioritize eth0. ###
echo '> Creating an /etc/vmware-tools/tools.conf to prioritize eth0...'
cat > /etc/vmware-tools/tools.conf << EOF
[guestinfo]
primary-nics=eth0
low-priority-nics=weave,docker0

[guestinfo]
exclude-nics=veth*,vxlan*,datapath
EOF

### Set the appliance version.
VERSION_FROM_BOM=$(jq -r < ${BOM_FILE} '.appliance.version')
cat > /etc/appliance-release << EOF
Version: ${VERSION_FROM_BOM}
EOF

echo '> Done.'
