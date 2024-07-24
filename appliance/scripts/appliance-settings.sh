#!/bin/bash -eux
# Copyright 2024 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2-Clause

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Configuring SSH for Public Key Authentication.
echo '> Configuring SSH for Public Key Authentication...'
sudo sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Setting the hostname.
echo '> Setting the hostname...'
sudo hostnamectl set-hostname localhost

# Disable IPv6.
echo '> Disabling IPv6...'
echo "net.ipv6.conf.all.disable_ipv6 = 1" | sudo tee -a /etc/sysctl.conf >/dev/null

# Apply the latest operating system updates.
echo '> Applying latest operating system updates...'
cd /etc/yum.repos.d/

for repo in photon.repo photon-updates.repo photon-extras.repo photon-debuginfo.repo; do
    sudo sed -i 's|dl.bintray.com/vmware|packages.vmware.com/photon/$releasever|g' "$repo"
done

sudo tdnf -y update photon-repos
sudo tdnf -y remove docker
sudo tdnf clean all
sudo tdnf makecache
sudo tdnf -y update

# Install additional packages.
echo '> Installing additional packages...'
sudo tdnf install -y \
    cdrkit \
    cronie \
    git \
    jq \
    logrotate \
    minimal \
    powershell \
    python3-pip \
    tar \
    unzip \
    wget

# Installing Python packages.
echo -e "\e[92mInstalling Python packages..."
BOM_FILE=/root/config/appliance.json
MASKPASS_VERSION=$(sudo sh -c "jq -r '.[\"maskpass\"].version' <${BOM_FILE}" | sed 's/v//g')

# Create the /opt/vmware directory.
sudo mkdir -p /opt/vmware

# Add root and admin users to a new group.
sudo groupadd vmware
sudo usermod -aG vmware root
sudo usermod -aG vmware admin

# Change the owner and permissions of the /opt/vmware directory.
sudo chown -R admin:vmware /opt/vmware
sudo chmod -R 775 /opt/vmware

# Create a Python virtual environment.
sudo python3 -m venv /opt/vmware/env

# Make the Python virtual environment the default for the admin user.
echo "source /opt/vmware/env/bin/activate" >>~/.bashrc

# Activate the Python virtual environment
source /opt/vmware/env/bin/activate

# Now we are in the virtual environment, we can safely upgrade pip and install packages
sudo pip install --upgrade pip
sudo pip install requests
sudo pip install paramiko
sudo pip install psutil
sudo pip install maskpass==${MASKPASS_VERSION}

# Create an /etc/vmware-tools/tools.conf to prioritize eth0.
echo '> Creating an /etc/vmware-tools/tools.conf to prioritize eth0...'
sudo tee /etc/vmware-tools/tools.conf >/dev/null <<EOF
[guestinfo]
primary-nics=eth0
low-priority-nics=weave,docker0

[guestinfo]
exclude-nics=veth*,vxlan*,datapath
EOF

# Add PATH to /etc/environment
echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' | sudo tee -a /etc/environment >/dev/null

echo '> Done.'
