#!/bin/bash -eux
# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Cleanup the appliance.

### Clear the tdnf cache. ###
echo '> Clearing tdnf cache...'
tdnf clean all

### Remove log files. ###
echo '> Removing log files...'
cat /dev/null > /var/log/wtmp 2>/dev/null
logrotate -f /etc/logrotate.conf 2>/dev/null
find /var/log -type f -delete
rm -rf /var/log/journal/*
rm -f /var/lib/dhcp/*

## Zero out the free space to save space in the final image. ###
echo '> Zeroing out the free space to save space in the final image....'
dd if=/dev/zero of=/EMPTY bs=1M || true; sync; sleep 1; sync
rm -f /EMPTY; sync; sleep 1; sync

### Set a random password for the root account. ###
echo '> Setting a random password for the root account...'
RANDOM_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
echo "root:${RANDOM_PASSWORD}" | /usr/sbin/chpasswd

### Clear the history. ###
echo '> Clearing the history ...'
unset HISTFILE && history -c && rm -fr /root/.bash_history

echo '> Done'
