# Sample Appliance: VMware Validated Solutions for VMware Cloud Foundation

## Overview

This repository provides an infrastructure-as-code example to automate the build of a virtual
appliance in Open Virtualization Archive (OVA) format for use with the VMware Validated Solutions.

The appliance is built using [HashiCorp Packer][packer] and the
[Packer Plugin for VMware vSphere][packer-plugin-vsphere-] using the `vsphere-iso` builder.

Learn more about the [VMware Validated Solutions][vvs].

## Requirements

The following component must be available on the system that will run the appliance build:

- HashiCorp [Packer][packer] 1.11.0 or later.
- HashiCorp [Packer Plugin for VMware vSphere][packer-plugin-vsphere] 1.3.0 or later.
- jq 1.7.1 or later.
- xorriso.
- Internet access.

  > [!NOTE]
  > The plugin is automatically downloaded and initialized when using `./appliance.sh`.

The target VMware vCenter Server endpoint must have a port group or segment with DHCP and Internet access.

Select an operating system name to display the installation steps for the requirements:

- <details>
    <summary>Photon OS</summary>

  1. Install HashiCorp Packer:

     ```shell
     PACKER_VERSION="1.11.0"
     OS_PACKAGES="wget unzip git"

     if [[ $(uname -m) == "x86_64" ]]; then
       LINUX_ARCH="amd64"
     elif [[ $(uname -m) == "aarch64" ]]; then
       LINUX_ARCH="arm64"
     fi

     tdnf install ${OS_PACKAGES} -y

     wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${LINUX_ARCH}.zip

     unzip -o -d /usr/local/bin/ packer_${PACKER_VERSION}_linux_${LINUX_ARCH}.zip
     ```

  2. Install additional packages:

     ```shell
     tdnf install jq xorriso -y
     ```

  </details>

- <details>
    <summary>Ubuntu</summary>

  1. Install HashiCorp Packer:

     The packages are signed using a private key controlled by HashiCorp, so you must configure your
     system to trust that HashiCorp key for package authentication.

     a. To configure your repository:

     ```shell
     bash -c 'wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg'
     ```

     b. Verify the key's fingerprint:

     ```shell
     gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
     ```

     c. Add the official HashiCorp repository to your system:

     ```shell
     bash -c 'echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
     https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list'
     ```

     d. Install Packer from HashiCorp repository:

     ```shell
     apt update && sudo apt install packer
     ```

  2. Install additional packages:

     ```shell
     apt -y install jq xorriso
     ```

  </details>

- <details>
    <summary>macOS</summary>

  1. Install HashiCorp Packer:

     ```shell
     brew tap hashicorp/tap

     brew install hashicorp/tap/packer
     ```

  1. Install additional packages:

     ```shell
     brew install jq
     ```

  </details>

## Build the Appliance

1. Clone the repository:

   ```console
   git clone https://github.com/vmware-samples/validated-solutions-for-cloud-foundation.git
   cd validated-solutions-for-cloud-foundation/appliance
   ```

2. Update the `vsphere_*` variables in `appliance.auto.pkrvars.hcl` for your environment.

3. Start the appliance build:

   ```console
   make
   ```

   or

   ```console
   ./appliance.sh
   ```

4. After the build process completes, the OVA is exported to the `artifacts` directory and the
   temporary machine image is destroyed.

> [!NOTE]
> The appliance build takes approximately 10 minutes to complete.

## Contributing

The project team welcomes contributions from the community. Before you start working with project,
please read our [Developer Certificate of Origin][vmware-cla-dco].

All contributions to this repository must be signed as described on that page. Your signature
certifies that you wrote the patch or have the right to pass it on as an open-source patch.

For more detailed information, refer to the [contribution guidelines][contributing] to get started.

## Support

While this project is not supported by VMware Support Services, it is supported by the project
maintainers and its community of users.

Use the GitHub [issues][gh-issues] to report bugs or suggest features and enhancements. Issues are
monitored by the maintainers and are prioritized based on criticality and community
[reactions][gh-reactions].

Before filing an issue, please search the issues and use the reactions feature to add votes to
matching issues. Please include as much information as you can. Details like these are incredibly
useful in helping the us evaluate and prioritize any changes:

- A reproducible test case or series of steps.
- Any modifications you've made relevant to the bug.
- Anything unusual about your environment or deployment.

You can also start a discussion on the GitHub [discussions][gh-discussions] area to ask questions or
share ideas.

## License

Copyright 2024 Broadcom. All Rights Reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions
   and the following disclaimer.

1. Redistributions in binary form must reproduce the above copyright notice, this list of conditions
   and the following disclaimer in the documentation and/or other materials provided with the
   distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[//]: Links
[contributing]: ../CONTRIBUTING.md
[gh-discussions]: https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/discussions
[gh-issues]: https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues
[gh-reactions]: https://blog.github.com/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/
[packer]: https://packer.io
[packer-plugin-vsphere]: https://developer.hashicorp.com/packer/integrations/hashicorp/vsphere
[vmware-cla-dco]: https://cla.vmware.com/dco
[vvs]: https://vmware.com/go/vvs
[vvs-hrm]: https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation
