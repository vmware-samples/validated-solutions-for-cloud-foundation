#!/bin/bash
# Copyright 2023 VMware, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-2

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

### Set the output and OVF paths. ###
echo "> Setting the output and OVF paths ..."
OUTPUT_PATH="../output-appliance"
OVF_PATH=$(find ${OUTPUT_PATH} -type f -iname ${APPLIANCE_NAME}.ovf -exec dirname "{}" \;)

### Move the OVF files. ###
echo "> Moving the OVF files to ${OUTPUT_PATH}/${APPLIANCE_NAME} ..."

if [ "${OUTPUT_PATH}" = "${OVF_PATH}" ]; then
    mkdir ${OUTPUT_PATH}/${APPLIANCE_NAME}
    mv ${OUTPUT_PATH}/*.* ${OUTPUT_PATH}/${APPLIANCE_NAME}
    OVF_PATH=${OUTPUT_PATH}/${APPLIANCE_NAME}
fi

### Remove the .mf file from the OVF directory. ###
echo "> Removing the ${OVF_PATH}/${APPLIANCE_NAME}.mf file from the OVF directory ..."
rm -f ${OVF_PATH}/${APPLIANCE_NAME}.mf

### Add the appliance version to the OVF template. ###
echo "> Adding the appliance version ${APPLIANCE_VERSION} to the OVF template ..."
sed "s/{{VERSION}}/${APPLIANCE_VERSION}/g" ${APPLIANCE_OVF_TEMPLATE} > photon.xml

if [ "$(uname)" == "Darwin" ]; then
    sed -i .bak1 's/<VirtualHardwareSection>/<VirtualHardwareSection ovf:transport="com.vmware.guestInfo">/g' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i .bak2 "/    <\/vmw:BootOrderSection>/ r photon.xml" ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i .bak3 '/^      <vmw:ExtraConfig ovf:required="false" vmw:key="nvram".*$/d' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i .bak4 "/^    <File ovf:href=\"${APPLIANCE_NAME}-file1.nvram\".*$/d" ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i .bak5 '/vmw:ExtraConfig.*/d' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
else
    sed -i 's/<VirtualHardwareSection>/<VirtualHardwareSection ovf:transport="com.vmware.guestInfo">/g' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i "/    <\/vmw:BootOrderSection>/ r photon.xml" ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i '/^      <vmw:ExtraConfig ovf:required="false" vmw:key="nvram".*$/d' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i "/^    <File ovf:href=\"${APPLIANCE_NAME}-file1.nvram\".*$/d" ${OVF_PATH}/${APPLIANCE_NAME}.ovf
    sed -i '/vmw:ExtraConfig.*/d' ${OVF_PATH}/${APPLIANCE_NAME}.ovf
fi

### Create the OVA file. ###
echo "> Creating the OVA file at ${OUTPUT_PATH}/${FINAL_APPLIANCE_NAME}.ova .."
ovftool ${OVF_PATH}/${APPLIANCE_NAME}.ovf ${OUTPUT_PATH}/${FINAL_APPLIANCE_NAME}.ova

### Remove files that are no longer required. ###
echo "> Removing files that are no longer required ..."
rm -rf ${OVF_PATH}
rm -f photon.xml

### Done! ###
echo "> Done!"
