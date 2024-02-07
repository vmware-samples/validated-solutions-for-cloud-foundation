#!/bin/bash
# Copyright 2023-2024 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Login Banner

set -euo pipefail

BOM_FILE=/root/config/appliance-bom.json
NAME_FROM_BOM=$(jq -r < ${BOM_FILE} '.appliance.name')
VERSION_FROM_BOM=$(jq -r < ${BOM_FILE} '.appliance.version')

echo -e "\e[92mCustomizing the appliance login banner..." > /dev/console
cat << EOF > /etc/issue
${NAME_FROM_BOM}
${VERSION_FROM_BOM}
EOF

/usr/sbin/agetty --reload
