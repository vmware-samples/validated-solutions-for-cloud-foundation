#!/bin/bash
# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -euo pipefail

### Locate the bill of materials file. ###
BOM_FILE=appliance-bom.json
echo "> Locating the ${BOM_FILE} file..."
if [ ! -e ${BOM_FILE} ]; then
    echo "Unable to locate the ${BOM_FILE} file in current directory."
    exit 1
fi

### Check if the jq utility is installed. ###
echo "> Checking if the jq utility is installed..."
if ! hash jq 2>/dev/null; then
    echo "The jq utility is not installed on this system."
    exit 1
fi

### Remove the previous appliance OVA output. ###
echo "> Removing the previous appliance OVA output..."
rm -f output-appliance/*.ova

### Extract the appliance version from the bill of materials file. ###
echo "> Extracting the appliance information from the ${BOM_FILE} file..."
NAME_FROM_BOM=$(jq -r < ${BOM_FILE} '.appliance.name')
VERSION_FROM_BOM=$(jq -r < ${BOM_FILE} '.appliance.version')

### Build the appliance. ###
echo "> Building the appliance..."

### Initialize HashiCorp Packer and the required plugins. ###
echo "> Initializing HashiCorp Packer and the required plugins..."
packer init .

### Start the build of the appliance. ###
echo "> Starting the build of ${NAME_FROM_BOM} ${VERSION_FROM_BOM}..."
packer build -force -var "appliance_version=${VERSION_FROM_BOM}" .
