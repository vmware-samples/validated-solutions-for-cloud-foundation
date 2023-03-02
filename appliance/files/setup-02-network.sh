#!/bin/bash
# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Setup Networking

set -euo pipefail

echo -e "\e[92mConfiguring the IP address..." > /dev/console
cat > /etc/systemd/network/99-dhcp-en.network << __CUSTOMIZE_PHOTON__
[Match]
Name=e*

[Network]
Address=${IP_ADDRESS}/${NETMASK}
Gateway=${GATEWAY}
DNS=${DNS_SERVER}
__CUSTOMIZE_PHOTON__

echo -e "\e[92mConfiguring DNS..." > /dev/console
rm -f /etc/resolv.conf
cat > /etc/resolv.conf <<EOF
nameserver ${DNS_SERVER}
search ${DNS_DOMAIN}
EOF

echo -e "\e[92mConfiguring NTP..." > /dev/console
cat > /etc/systemd/timesyncd.conf << __CUSTOMIZE_PHOTON__

[Match]
Name=e*

[Time]
NTP=${NTP_SERVER}
__CUSTOMIZE_PHOTON__

echo -e "\e[92mConfiguring the hostname ..." > /dev/console
echo "${IP_ADDRESS} ${HOSTNAME}" >> /etc/hosts
hostnamectl set-hostname ${HOSTNAME}

echo -e "\e[92mRestarting the networkd..." > /dev/console
systemctl restart systemd-networkd

echo -e "\e[92mRestarting timesyncd..." > /dev/console
systemctl restart systemd-timesyncd

echo -e "\e[92mDisabling cloud-init..." > /dev/console
### Disables cloud-init to ensure the hostname is preserved across reboots. ###
touch /etc/cloud/cloud-init.disabled
