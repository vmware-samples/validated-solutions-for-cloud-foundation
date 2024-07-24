#!/bin/bash -eux
# Copyright 2023-2024 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Setting appliance version
echo '> Setting appliance version...'
BOM_FILE=/root/config/appliance.json
APPLIANCE_VERSION=$(sudo sh -c "jq -r '.appliance.version' <${BOM_FILE}")
echo "v${APPLIANCE_VERSION}" | sudo tee /etc/appliance-release

# Clearing the tdnf cache.
echo '> Clearing tdnf cache...'
sudo tdnf clean all

# Removing log files.
echo '> Removing log files...'
sudo sh -c 'cat /dev/null > /var/log/wtmp' 2>/dev/null
sudo logrotate -f /etc/logrotate.conf 2>/dev/null
sudo find /var/log -type f -delete
sudo rm -rf /var/log/journal/*
sudo rm -f /var/lib/dhcp/*

# Removing the SSH host keys.
echo '> Removing the SSH host keys...'
sudo rm -f /var/log/audit/audit.log
sudo rm -f /var/log/lastlog
sudo rm -f /var/log/wtmp

# Cleaning persistent udev rules.
echo '> Cleaning persistent udev rules...'
sudo rm -f /etc/udev/rules.d/70-persistent-net.rules

# Cleaning the /tmp directories.
echo '> Cleaning the /tmp directories...'
sudo find /tmp /var/tmp -type f -exec rm -f {} \;

# Cleaning the SSH host keys.
echo '> Cleaning the SSH host keys...'
sudo find /etc/ssh -name 'ssh_host_*' -exec rm -f {} \;

## Zeroing out the free space to save space in the final image.
echo '> Zeroing out the free space to save space in the final image....'
sudo dd if=/dev/zero of=/EMPTY bs=1M || true
sync
sleep 1
sync
sudo rm -f /EMPTY
sync
sleep 1
sync

# Cleaning the machine-id.
echo '> Cleaning the machine-id...'
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id

# Clearing the history.
echo '> Clearing the history ...'
unset HISTFILE && history -c
sudo rm -f ~/.bash_history
sudo rm -f /root/.bash_history

echo '> Done'
