# Sample Appliance: Health Reporting and Monitoring for VMware Cloud Foundation

## Overview

This repository provides an infrastructure-as-code example to automate the build of a virtual appliance in Open Virtualization Appliance (OVA) format for use with the [Health Reporting and Monitoring for VMware Cloud Foundation][vvs-hrm] validated solution.

The appliance is built using [HashiCorp Packer][packer] and the [Packer Plugin for VMware][packer-plugin-vmware] using the `vmware-iso` builder.

Learn more about the [VMware Validated Solutions][vvs].

## Requirements

**Packer**:

- HashiCorp [Packer][packer] 1.9.4 or higher.

  > **Note**
  >
  > Click on the operating system name to display the installation steps.

  - <details>
      <summary>Photon OS</summary>

    ```shell
    PACKER_VERSION="1.9.4"
    OS_PACKAGES="wget unzip"

    if [[ $(uname -m) == "x86_64" ]]; then
      LINUX_ARCH="amd64"
    elif [[ $(uname -m) == "aarch64" ]]; then
      LINUX_ARCH="arm64"
    fi

    tdnf install ${OS_PACKAGES} -y

    wget -q https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${LINUX_ARCH}.zip

    unzip -o -d /usr/local/bin/ packer_${PACKER_VERSION}_linux_${LINUX_ARCH}.zip
    ```

    </details>

  - <details>
      <summary>Ubuntu</summary>

    The packages are signed using a private key controlled by HashiCorp, so you must configure your system to trust that HashiCorp key for package authentication.

    To configure your repository:

    ```shell
    sudo bash -c 'wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor > /usr/share/keyrings/hashicorp-archive-keyring.gpg'
    ```

    Verify the key's fingerprint:

    ```shell
    gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
    ```

    Add the official HashiCorp repository to your system:

    ```shell
    sudo bash -c 'echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list'
    ```

    Install Packer from HashiCorp repository:

    ```shell
    sudo apt update && sudo apt install packer
    ```

    </details>

  - <details>
      <summary>macOS</summary>

    ```shell
    brew tap hashicorp/tap

    brew install hashicorp/tap/packer
    ```

    </details>

- Packer plugin:

  > **Note**
  >
  > The required plugin is automatically downloaded and initialized when using `./appliance-build.sh`. For dark sites, you may download the plugin and place it in same directory as your Packer executable `/usr/local/bin` or `$HOME/.packer.d/plugins`.

  - HashiCorp [Packer Plugin for VMware][packer-plugin-vmware] 1.0.10 or higher.

## Build the Appliance

1. Clone the repository:

   ```console
   git clone https://github.com/vmware-samples/validated-solutions-for-cloud-foundation.git
   cd validated-solutions-for-cloud-foundation/appliance
   ```

2. Start the appliance build:

   ```console
   ./appliance-build.sh
   ```

   > **Note**
   >
   > The appliance build takes approximately 10 minutes to complete.

3. After the build process completes, the OVA is exported to the `output-appliance` directory and the temporary machine image is destroyed.

## Contributing

The project team welcomes contributions from the community. Before you start working with project, please read our
[Developer Certificate of Origin][vmware-cla-dco].

All contributions to this repository must be signed as described on that page. Your signature certifies that you wrote
the patch or have the right to pass it on as an open-source patch.

For more detailed information, refer to the [contribution guidelines][contributing] to get started.

## Support

While this project is not supported by VMware Support Services, it is supported by the project maintainers and its community of users.

Use the GitHub [issues][gh-issues] to report bugs or suggest features and enhancements. Issues are monitored by the maintainers and are prioritized based on criticality and community [reactions][gh-reactions].

Before filing an issue, please search the issues and use the reactions feature to add votes to matching issues. Please include as much information as you can. Details like these are incredibly useful in helping the us evaluate and prioritize any changes:

- A reproducible test case or series of steps.
- Any modifications you've made relevant to the bug.
- Anything unusual about your environment or deployment.

You can also start a discussion on the GitHub [discussions][gh-discussions] area to ask questions or share ideas.

## License

Copyright 2023 VMware, Inc.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the
following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following
disclaimer.

1. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following
disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES;LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[//]: Links

[contributing]: ../CONTRIBUTING.md
[gh-discussions]: https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/discussions
[gh-issues]: https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues
[gh-reactions]: https://blog.github.com/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/
[packer]: https://packer.io
[packer-plugin-vmware]: https://developer.hashicorp.com/packer/integrations/hashicorp/vmware
[vmware-cla-dco]: https://cla.vmware.com/dco
[vvs]: https://vmware.com/go/vvs
[vvs-hrm]: https://core.vmware.com/health-reporting-and-monitoring-vmware-cloud-foundation
