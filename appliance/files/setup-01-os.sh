#!/bin/bash
# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# OS Settings

set -euo pipefail

echo -e "\e[92mConfiguring sshd..." > /dev/console

if [ "${ENABLE_SSH}" == "true" ]; then
    systemctl enable sshd
    systemctl start sshd
else
    systemctl disable sshd
    systemctl stop sshd
fi

echo -e "\e[92mSetting the root password..." > /dev/console
echo "root:${ROOT_PASSWORD}" | /usr/sbin/chpasswd
    