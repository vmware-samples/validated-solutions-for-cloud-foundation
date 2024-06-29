#!/bin/bash
# Copyright 2024 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2-Clause

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Seting the paths.
echo "> Setting the paths..."
OUTPUT_PATH="../artifacts"
OVF_PATH=$(find ${OUTPUT_PATH} -type f -iname ${APPLIANCE_NAME}.ovf -exec dirname "{}" \;)

# Moving the OVF files.
echo "> Moving the OVF files to ${OUTPUT_PATH}/${APPLIANCE_NAME}..."

if [ "${OUTPUT_PATH}" = "${OVF_PATH}" ]; then
    mkdir ${OUTPUT_PATH}/${APPLIANCE_NAME}
    mv ${OUTPUT_PATH}/*.* ${OUTPUT_PATH}/${APPLIANCE_NAME}
    OVF_PATH=${OUTPUT_PATH}/${APPLIANCE_NAME}
fi

# Adding the appliance version to the OVF template.
echo "> Adding the appliance version ${APPLIANCE_VERSION} to the OVF template..."
sed "s/{{VERSION}}/${APPLIANCE_VERSION}/g" ${APPLIANCE_OVF_TEMPLATE} >appliance.xml

if [ "$(uname)" == "Darwin" ]; then
    sed -i .bak1 's/<VirtualHardwareSection>/<VirtualHardwareSection ovf:transport="com.vmware.guestInfo">/g' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i .bak2 "/    <\/vmw:BootOrderSection>/ r appliance.xml" ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i .bak3 '/^      <vmw:ExtraConfig ovf:required="false" vmw:key="nvram".*$/d' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i .bak4 "/^    <File ovf:href=\"${APPLIANCE_NAME}-file1.nvram\".*$/d" ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i .bak5 '/vmw:ExtraConfig.*/d' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
else
    sed -i 's/<VirtualHardwareSection>/<VirtualHardwareSection ovf:transport="com.vmware.guestInfo">/g' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i "/    <\/vmw:BootOrderSection>/ r appliance.xml" ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i '/^      <vmw:ExtraConfig ovf:required="false" vmw:key="nvram".*$/d' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i "/^    <File ovf:href=\"${APPLIANCE_NAME}-file1.nvram\".*$/d" ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i '/vmw:ExtraConfig.*/d' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
fi

# Extracting the original SHA256 checksum from the .mf file.
ORIGINAL_CHECKSUM=$(grep "^SHA256(${APPLIANCE_NAME}.ovf)= " ${OVF_PATH}/${APPLIANCE_NAME}.mf | awk '{ print $2 }')

# Computing the new SHA256 checksum for the .ovf file.
UPDATED_CHECKSUM=$(shasum -a 256 ${OVF_PATH}/${APPLIANCE_NAME}.ovf | awk '{ print $1 }')

# Printing the original and new checksums.
echo "Original Checksum: ${ORIGINAL_CHECKSUM}"
echo "Updated Checksum: ${UPDATED_CHECKSUM}"

# Updating the .mf file with the new checksum.
sed -i '' "s/^SHA256(${APPLIANCE_NAME}.ovf)= .*/SHA256(${APPLIANCE_NAME}.ovf)= ${UPDATED_CHECKSUM}/" ${OVF_PATH}/${APPLIANCE_NAME}.mf

# Sleeping for 5 seconds to allow the checksum to be updated before creating the OVA file.
sleep 5

# Creating the OVA file.
echo "> Creating the OVA file at ${OUTPUT_PATH}/${FINAL_APPLIANCE_NAME}.ova..."
ovftool ${OVF_PATH}/${APPLIANCE_NAME}.ovf ${OUTPUT_PATH}/${FINAL_APPLIANCE_NAME}.ova

# Removing files that are no longer required.
echo "> Removing files that are no longer required..."
rm -rf ${OVF_PATH}
rm -f appliance.xml

echo "> Done!"
