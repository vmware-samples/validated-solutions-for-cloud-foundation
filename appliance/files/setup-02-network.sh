#!/bin/bash
# Copyright 2024 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2-Clause

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Setup Networking

set -euo pipefail

# Setting the IP address.
echo -e "\e[92mSetting the IP address..." >/dev/console
cat >/etc/systemd/network/50-dhcp-en.network <<__CUSTOMIZE_PHOTON__
[Match]
Name=e*

[Network]
Address=${IP_ADDRESS}/${NETMASK}
Gateway=${GATEWAY}
DNS=${DNS_SERVER}
__CUSTOMIZE_PHOTON__

# Setting the DNS configuration.
echo -e "\e[92mSetting the DNS configuration..." >/dev/console
rm -f /etc/resolv.conf
cat >/etc/resolv.conf <<EOF
nameserver ${DNS_SERVER}
search ${DNS_DOMAIN}
EOF

# Setting the NTP configuration.
echo -e "\e[92mSetting the NTP configuration...." >/dev/console
cat >/etc/systemd/timesyncd.conf <<__CUSTOMIZE_PHOTON__

[Match]
Name=e*

[Time]
NTP=${NTP_SERVER}
__CUSTOMIZE_PHOTON__

# Setting the hostname.
echo -e "\e[92mSetting the hostname..." >/dev/console
echo "${IP_ADDRESS} ${HOSTNAME}" >>/etc/hosts
hostnamectl set-hostname ${HOSTNAME}

# Restarting networkd.
echo -e "\e[92mRestarting networkd..." >/dev/console
systemctl restart systemd-networkd

# Restarting timesyncd.
echo -e "\e[92mRestarting timesyncd..." >/dev/console
systemctl restart systemd-timesyncd

# Disabling cloud-init.
echo -e "\e[92mDisabling cloud-init..." >/dev/console
touch /etc/cloud/cloud-init.disabled
