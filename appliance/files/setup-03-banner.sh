#!/bin/bash
# Copyright 2024 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2-Clause

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Login Banner

set -euo pipefail

# Set the variables.
BOM_FILE=/root/config/appliance.json
APPLIANCE_NAME=$(jq -r '.appliance.name' <${BOM_FILE})
APPLIANCE_VERSION=$(jq -r '.appliance.version' <${BOM_FILE})

# Setting the appliance login banner.
echo -e "\e[92mSetting the appliance login banner..." >/dev/console
cat <<EOF >/etc/issue
Welcome to ${APPLIANCE_NAME} v${APPLIANCE_VERSION}
EOF

/usr/sbin/agetty --reload
