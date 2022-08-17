[Back](README.md)

# Configure Content Libraries in vSphere

Content libraries are containers for VM templates, vApp templates, and other resources used for vRealize Automation deployment of virtual machines and vApps. Sharing templates and files across multiple vCenter Server instances brings out consistency, compliance, efficiency, and automation in deploying workloads at scale.

You create and manage a content library from a single vCenter Server instance. If HTTPS traffic is allowed between vCenter Server instances, you can share the library items.

## Procedures

1. [Configure a Publishing Content Library on the First VI Workload Domain vCenter Server](#configure-a-publishing-content-library-on-the-first-vi-workload-domain-vcenter-server)

   Create a content library for images that you can use to deploy virtual machines in your environment. You enable publishing for the content library, so that you can synchronize the images among different VI workload domain vCenter Server instances and ensure that all images in your environment are consistent.

2. [Import OVF Images to the Publishing Content Library on the First VI Workload Domain vCenter Server](#import-ovf-images-to-the-publishing-content-library-on-the-first-vi-workload-domain-vcenter-server)

   You can import virtual machine images in OVF format into a publishing content library to use for image mappings in vRealize Automation.

3. [Configure Subscribed Content Libraries on an Additional VI Workload Domain vCenter Server](#configure-subscribed-content-libraries-on-an-additional-vi-workload-domain-vcenter-server)

   To ensure that all virtual machine images in your environment are consistent, synchronize templates among the different VI workload domain vCenter Server instances. Connect subscribed content libraries on the additional VI workload domain vCenter Server instances to the previously published content library on the first VI workload domain vCenter Server instance.

### Configure a Publishing Content Library on the First VI Workload Domain vCenter Server

Create a content library for images that you can use to deploy virtual machines in your environment. You enable publishing for the content library, so that you can synchronize the images among different VI workload domain vCenter Server instances and ensure that all images in your environment are consistent.

#### UI Procedure

1. Log in to the management domain vCenter Server at **`https://<management_vcenter_server_fqdn>/ui`** as **administrator@vsphere.local**.

2. In the **Content libraries** inventory, click **Create**.

3. On the **Name and location** page, configure the settings and click **Next**.

   | **Setting**     | **Value**                               |
   | :-              | :-                                      |
   | Name            | sfo-w01-lib01                           |
   | Notes           | Publishing Content Library for sfo-w01  |
   | vCenter Server  | sfo-w01-vc01.sfo.rainpole.io            |

4. On the **Configure content library** page, configure the settings and click **Next**.

   | **Setting**            | **Value**   |
   | :-                     | :-          |
   | Local content library  | Selected    |
   | Enable publishing	    | Selected    |
   | Enable authentication  | Disabled    |

5. On the **Add storage** page, select the storage location **sfo-w01-cl01-ds-vsan01** and click **Next**.

6. On the **Ready to complete** page, click **Finish**.

#### Terraform Procedure

1. Navigate to the Terraform example in the repository.

   ```powershell
   cd terraform-examples/vsphere/vsphere-content-library-publishing
   ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

   ```powershell
   cd terraform-examples/vsphere/vsphere-content-library-publishing
   ```

3. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

4. Initialize the current directory and the required Terraform providers.

   ```powershell
   terraform init
   ```

5. Create a Terraform plan and save the output to a file.

   ```powershell
   terraform plan -out=tfplan
   ```

6. Apply the Terraform plan.

   ```powershell
   terraform plan -out=tfplan
   ```

#### PowerShell Procedure

1. Start Windows PowerShell.

2. Replace the values in the sample code with values from your *VMware Cloud Foundation Planning and Preparation Workbook* and run the commands in the PowerShell console.

   ```powershell
   $sddcManagerFqdn = "sfo-vcf01.sfo.rainpole.io"
   $sddcManagerUser = "administrator@vsphere.local"
   $sddcManagerPass = "VMw@re1!"

   $contentLibraryName = "sfo-w01-lib01"
   $sddcDomainName = "sfo-w01"
   ```

3. Perform the configuration by running the command in the PowerShell console.

   ```powershell
   Add-ContentLibrary -server $sddcManagerFqdn -user $sddcManagerUser -pass $sddcManagerPass -domain $sddcDomainName -contentLibraryName $contentLibraryName -published
   ```

### Import OVF Images to the Publishing Content Library on the First VI Workload Domain vCenter Server

You can import virtual machine images in OVF format into a publishing content library to use for image mappings in vRealize Automation. 

In the sample, the following operating system images are used:

   | Operating System         | Virtual Machine Template Name  |
   | :-                       | :-                             |
   | Ubuntu Server LTS        | linux-ubuntu-server-lts        |
   | Windows Server Standard  | windows-server-standard        |

Learn more about creating machine images with HashiCorp Packer and the Packer Plugin for VMware vSphere `vsphere-iso` by visiting the [vmware-samples/packer-examples-for-vsphere](https://github.com/vmware-samples/packer-examples-for-vsphere) GitHub project.

#### UI Procedure

1. Log in to vCenter Server at **`https://<vcenter_server_fqdn>/ui`** with a user assigned the **Administrator** role.

2. In the **VMs and templates** inventory, expand the VI workload domain vCenter Server tree.

3. Expand the VI workload domain data center and expand the VM and template folder for your templates.

4. Right-click a virtual machine template for the Ubuntu Server LTS operating system and select **Clone to library**.

5. In the **Clone to template in library** dialog box, configure the settings and click **OK**.

   | Setting         | Example Value            |
   | :-              | :-                       |
   | Clone as        | New template             |
   | Content library | sfo-w01-lib01            |
   | Template name	| linux-ubuntu-server-lts  |
   | Notes           | Ubuntu Server LTS        |

6. Repeat the procedure for the virtual machine template for the Windows Server Standard operating system.

#### Terraform / PowerShell Procedure

1. Navigate to the Terraform example in the repository.

   ```powershell
   cd terraform-examples/vsphere/vsphere-content-library-items
   ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

   ```powershell
   copy terraform.tfvars.example terraform.tfvars
   ```

3. Obtain the UUIDs of your virtual machine images by using PowerCLI.

   a. Start Windows PowerShell and define the environment variables by running the following commands.

   ```powershell
   $vCenterFqdn = "sfo-w01-vc01.sfo.rainpole.io"
   $vCenterUser = "administrator@vsphere.local"
   $vCenterPass = "VMw@re1!"
   ```

   b. Connect to the VI workload domain vCenter Server and obtain the UUIDs of your virtual machine images that are in templates folder by running the following VMware PowerCLI cmdlets.

   ```powershell
   Connect-VIServer $vCenterFqdn -User $vCenterUser -Password $vCenterPass
   Get-Template -Name linux-ubuntu-server-lts -Location (Get-Folder -Name "templates") | %{(Get-View $_.Id).config.uuid}
   Get-Template -name windows-server-standard -Location (Get-Folder -Name "templates") | %{(Get-View $_.Id).config.uuid}
   ```

   c. Disconnect from the VI workload domain vCenter Server.

   ```powershell
   Disconnect-VIServer $vCenterFqdn -Confirm:$false
   ```

4. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

   For the `source_uuid` variables, use the obtained UUIDs of the virtual machine images.

5. Initialize the current directory and the required Terraform providers.

   ```hcl
   terraform init
   ```

6. Create a Terraform plan and save the output to a file.

   ```powershell
   terraform plan -out=tfplan
   ```  

7. Apply the Terraform plan.

   ```powershell
   terraform apply tfplan
   ```   

#### What to do next?

Initialize an on-demand image synchronization for the vCenter Server cloud account in vRealize Automation.

1. Log in to the vRealize Automation at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Cloud Assembly**.

4. Click the **Infrastructure** tab.

5. in the left pane, select **Connections > Cloud accounts**.

6. In the card for the VI workload domain vCenter Server cloud account and click **Open**.

7. On the cloud account page, click **Sync images**.

### Configure Subscribed Content Libraries on an Additional VI Workload Domain vCenter Server

To ensure that all virtual machine images in your environment are consistent, synchronize templates among the different VI workload domain vCenter Server instances. Connect subscribed content libraries on the additional VI workload domain vCenter Server instances to the previously published content library on the first VI workload domain vCenter Server instance.

#### UI Procedure

1. Log in to vCenter Server at **`https://<vcenter_server_fqdn>/ui`** with a user assigned the **Administrator** role.

2. Copy the subscription URL of the published content library on the first VI workload domain vCenter Server.

   a. In the **Content libraries** inventory, click the published content library that you created for the first VI workload domain vCenter Server, **sfo-w01-lib01**.

   b. On the **Summary** tab, in the **Publication** panel, click **Copy link**.

3. Create the subscribed content library on the additional VI workload domain vCenter Server.

   a	In the **Content libraries** inventory, click **Create**.

   b. On the **Name and location** page, configure these settings and click **Next**.

      | Setting         | Example Value                           |   
      | :-              | :-                                      |
      | Name            | sfo-w02-lib01                           |
      | Notes           | Subscribed Content Library for sfo-w02  |
      | vCenter Server  | sfo-w02-vc01.sfo.rainpole.io            |

   c. On the **Configure content library** page, configure these settings and click **Next**.

      | Setting                     | Example Value                                 |
      | :-                          | :-                                            |
      | Subscribed content library  | Selected                                      |
      | Subscription URL	         | Paste the URL that you copied in step [2]().  |
      | Enable authentication       | Disabled                                      |
      | Download content            | Immediately                                   |

   d. On the **Add storage** page, select the storage location **sfo-w02-cl01-ds-vsan01** and click **Next**.

   e. On the **Ready to complete page**, click **Finish**.

   In the **Recent tasks** pane, a **Transfer files** status indicates the time to finish the file transfer.

#### Terraform Procedure

1. Navigate to the Terraform example in the repository.

   ```powershell
   cd terraform-examples/vsphere/vsphere-content-library-subscription
   ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

   ```powershell
   copy terraform.tfvars.example terraform.tfvars
   ```

3. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

4. Initialize the current directory and the required Terraform providers.

   ```powershell
   terraform init
   ```

5. Create a Terraform plan and save the output to a file.

   ```powershell
   terraform plan -out=tfplan
   ```

6. Apply the Terraform plan.

   ```powershell
   terraform apply tfplan
   ```

#### PowerShell Procedure

1. Start Windows PowerShell.

2. Replace the values in the sample code with values from your *VMware Cloud Foundation Planning and Preparation Workbook* and run the commands in the PowerShell console.

   ```powershell
   $sddcManagerFqdn = "sfo-vcf01.sfo.rainpole.io"
   $sddcManagerUser = "administrator@vsphere.local"
   $sddcManagerPass = "VMw@re1!"

   $contentLibraryName = "sfo-w01-lib02"
   $sddcDomainName = "sfo-w02"
   $subscriptionUrl = "URL from Published Library"
   ```

3. Perform the configuration by running the command in the PowerShell console.

   ```powershell
   Add-ContentLibrary -server $sddcManagerFqdn -user $sddcManagerUser -pass $sddcManagerPass -domain $sddcDomainName -contentLibraryName $contentLibraryName -subscriptionUrl $subscriptionUrl
   ```

[Back: Home](README.md) 

[Next: Configure Customization Specifications in vSphere](2-configure-custom-specs.md)
