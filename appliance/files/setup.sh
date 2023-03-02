#!/bin/bash
# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -euo pipefail

# Extract all OVF Properties
APPLIANCE_DEBUG=$(/root/setup/getOvfProperty.py "guestinfo.debug")
HOSTNAME=$(/root/setup/getOvfProperty.py "guestinfo.hostname" | tr '[:upper:]' '[:lower:]')
IP_ADDRESS=$(/root/setup/getOvfProperty.py "guestinfo.ipaddress")
NETMASK=$(/root/setup/getOvfProperty.py "guestinfo.netmask" | awk -F ' ' '{print $1}')
GATEWAY=$(/root/setup/getOvfProperty.py "guestinfo.gateway")
DNS_SERVER=$(/root/setup/getOvfProperty.py "guestinfo.dns")
DNS_DOMAIN=$(/root/setup/getOvfProperty.py "guestinfo.domain")
NTP_SERVER=$(/root/setup/getOvfProperty.py "guestinfo.ntp")
ROOT_PASSWORD=$(/root/setup/getOvfProperty.py "guestinfo.root_password")
ENABLE_SSH=$(/root/setup/getOvfProperty.py "guestinfo.enable_ssh" | tr '[:upper:]' '[:lower:]')

if [ -e /root/ran_customization ]; then
    exit
else
	APPLIANCE_LOG_FILE=/var/log/bootstrap.log
	if [ ${APPLIANCE_DEBUG} == "True" ]; then
		APPLIANCE_LOG_FILE=/var/log/bootstrap-debug.log
		set -x
		exec 2>> ${APPLIANCE_LOG_FILE}
		echo
        echo "### WARNING -- DEBUG LOG CONTAINS ALL EXECUTED COMMANDS WHICH INCLUDES CREDENTIALS -- WARNING ###"
        echo "### WARNING --             PLEASE REMOVE CREDENTIALS BEFORE SHARING LOG            -- WARNING ###"
        echo
	fi

	# Slicing of escaped variables needed to properly handle the double quotation issue
	ESCAPED_ROOT_PASSWORD=$(eval echo -n '${ROOT_PASSWORD}' | jq -Rs .)
	
	cat > /root/config/appliance-config.json <<EOF
	
{
	"APPLIANCE_DEBUG": "${APPLIANCE_DEBUG}",
	"HOSTNAME": "${HOSTNAME}",
	"IP_ADDRESS": "${IP_ADDRESS}",
	"NETMASK": "${NETMASK}",
	"GATEWAY": "${GATEWAY}",
	"DNS_SERVER": "${DNS_SERVER}",
	"DNS_DOMAIN": "${DNS_DOMAIN}",
	"NTP_SERVER": "${NTP_SERVER}",
	"ESCAPED_ROOT_PASSWORD": ${ESCAPED_ROOT_PASSWORD},
	"ENABLE_SSH": "${ENABLE_SSH}",
}
EOF

	### Start the firstboot customization. ###
	echo -e "\e[92mStarting firstboot customization..." > /dev/console

	### Start the guest OS configuration. ###
	. /root/setup/setup-01-os.sh

	### Start the network configuration. ###
	. /root/setup/setup-02-network.sh

	### Customize the login banner. ###
	. /root/setup/setup-099-banner.sh

	### Debug: Clear the guestinfo.ovfEnv property. ##
	if [ ${APPLIANCE_DEBUG} == "False" ]; then
		vmtoolsd --cmd "info-set guestinfo.ovfEnv NULL"
	fi

	### Ensure that the bootstrap customization is only run once. ###
	touch /root/ran_customization
	sleep 5

	echo -e "\e[92mCompleted the firstboot customization." > /dev/console
	echo -e "\e[92mRebooting the appliance. Standby..." > /dev/console
	sleep 5
	reboot
fi
