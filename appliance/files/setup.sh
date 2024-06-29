#!/bin/bash
# Copyright 2023-2024 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -euo pipefail

# Extracting all OVF properties.
HOSTNAME=$(/root/setup/getOvfProperty.py "guestinfo.hostname" | tr '[:upper:]' '[:lower:]')
IP_ADDRESS=$(/root/setup/getOvfProperty.py "guestinfo.ipaddress")
NETMASK=$(/root/setup/getOvfProperty.py "guestinfo.netmask" | awk -F ' ' '{print $1}')
GATEWAY=$(/root/setup/getOvfProperty.py "guestinfo.gateway")
DNS_SERVER=$(/root/setup/getOvfProperty.py "guestinfo.dns")
DNS_DOMAIN=$(/root/setup/getOvfProperty.py "guestinfo.domain")
NTP_SERVER=$(/root/setup/getOvfProperty.py "guestinfo.ntp")
ADMIN_PASSWORD=$(/root/setup/getOvfProperty.py "guestinfo.admin_password")
ENABLE_SSH=$(/root/setup/getOvfProperty.py "guestinfo.enable_ssh" | tr '[:upper:]' '[:lower:]')

if [ -e /root/ran_customization ]; then
	exit
else
	APPLIANCE_LOG_FILE=/var/log/bootstrap.log

	# Slicing of escaped variables needed to properly handle the double quotation issue
	ESCAPED_ADMIN_PASSWORD=$(eval echo -n '${ADMIN_PASSWORD}' | jq -Rs .)

	cat >/root/config/appliance-config.json <<EOF

{
	"HOSTNAME": "${HOSTNAME}",
	"IP_ADDRESS": "${IP_ADDRESS}",
	"NETMASK": "${NETMASK}",
	"GATEWAY": "${GATEWAY}",
	"DNS_SERVER": "${DNS_SERVER}",
	"DNS_DOMAIN": "${DNS_DOMAIN}",
	"NTP_SERVER": "${NTP_SERVER}",
	"ESCAPED_ADMIN_PASSWORD": ${ESCAPED_ADMIN_PASSWORD},
	"ENABLE_SSH": "${ENABLE_SSH}"
}
EOF

	# Starting the first boot customization.
	echo -e "\e[92mStarting first first boot customization..." >/dev/console

	# Starting the guest OS configuration.
	. /root/setup/setup-01-os.sh

	# Starting the network configuration.
	. /root/setup/setup-02-network.sh

	# Customizing the login banner.
	. /root/setup/setup-03-banner.sh

	# Clearing the guestinfo.ovfEnv property.
	vmtoolsd --cmd "info-set guestinfo.ovfEnv NULL"

	# Ensuring that the bootstrap customization is only run once.
	touch /root/ran_customization
	sleep 5

	# Cleaning up.
	rm -rf /root/setup
	rm -rf /root/config
	rm -rf /etc/rc.d/rc.local

	# Rebooting the appliance.
	echo -e "\e[92mCompleted the first boot customization." >/dev/console
	echo -e "\e[92mRebooting the appliance. Standby..." >/dev/console
	sleep 5
	reboot
fi
