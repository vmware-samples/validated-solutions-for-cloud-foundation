#!/bin/bash
# Copyright 2024 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2-Clause

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set -euo pipefail

# Locate the bill of materials file
BOM_FILE=appliance.json
echo "> Locating the ${BOM_FILE} file..."
if [ ! -e ${BOM_FILE} ]; then
    echo "Unable to locate the ${BOM_FILE} file in current directory."
    exit 1
fi

APPLIANCE_NAME=$(jq -r '.appliance.name' <${BOM_FILE})
APPLIANCE_VERSION=$(jq -r '.appliance.version' <${BOM_FILE})
ARTIFACT_NAME=$(jq -r '.appliance.artifactName' <${BOM_FILE})

# Checking if jq is installed
echo "> Checking if jq is installed..."
if ! hash jq 2>/dev/null; then
    echo "jq is not installed on this system."
    exit 1
fi

# Checking if packer is installed.
echo "> Checking if packer is installed..."
if ! hash packer 2>/dev/null; then
    echo "packer is not installed on this system."
    exit 1
fi

# Checking if the artifact path exists.
echo "> Checking if the artifacts path exists..."
if [ ! -d "artifacts" ]; then
    echo "> Adding the artifacts path for the output..."
    mkdir artifacts
fi

# Removing any previous appliance artifacts.
echo "> Removing any previous appliance artifacts..."
rm -rf artifacts/*

# Initializing Packer and required plugins.
echo "> Initializing Packer and required plugins..."
packer init .

# Building the appliance.
echo "> Building ${APPLIANCE_NAME} ${APPLIANCE_VERSION}..."
build_password=$(openssl rand -base64 12)
root_password=$(openssl rand -base64 12)
packer build -force -var "appliance_version=${APPLIANCE_VERSION}" -var "appliance_name=${APPLIANCE_NAME}" -var "appliance_artifact_name=${ARTIFACT_NAME}" -var "build_password=$build_password" -var "root_password=$root_password" .
