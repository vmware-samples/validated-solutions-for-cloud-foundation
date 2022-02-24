# Configure Customization Specifications in vSphere

Create customization specifications, one for Linux and one for Windows, for use by the virtual machines images you deploy. Customization specifications are XML files that contain system configuration settings for the guest operating systems used in the virtual machines. You can use the customization specifications when you create cloud templates in vRealize Automation.

## Procedure

1. [Create a Customization Specification for Linux Guest Operating Systems](#create-a-customization-specification-for-linux-guest-operating-systems)

    Create a Linux guest operating system specification that you can apply when you create cloud templates for use with vRealize Automation. This customization specification can be used to customize virtual machine guest operating systems when provisioning new virtual machines from vRealize Automation.

2. [Create a Customization Specification for Windows Guest Operating Systems](#create-a-customization-specification-for-windows-guest-operating-systems)

    Create a Windows guest operating system specification that you can apply when you create cloud templates for use with vRealize Automation. This customization specification can be used to customize virtual machine guest operating systems when provisioning new virtual machines from vRealize Automation.

### Create a Customization Specification for Linux Guest Operating Systems

Create a Linux guest operating system specification that you can apply when you create cloud templates for use with vRealize Automation. This customization specification can be used to customize virtual machine guest operating systems when provisioning new virtual machines from vRealize Automation.

#### UI Procedure

1. Log in to vCenter Server at **https://<vcenter\_server\_fqdn>/ui** with a user assigned the **Administrator** role.

2. Select **Menu > Policies and profiles**.

3. In the left pane, click **VM customization specifications**.

4. On the **VM customization specifications** page, click the **Create a new specification** icon.

    The **New VM guest customization** wizard opens.

5. On the **Name and target OS** page, configure the settings and click **Next**.

    | Setting           | Example Value                 |
    | :-                | :-                            |
    | Name              | linux-ubuntu-server-lts       |
    | Description       | Ubuntu Linux Server LTS       |
    | vCenter Server    | sfo-w01-vc01.sfo.rainpole.io  |
    | Target guest OS	| Linux                         |

6. On the **Computer name** page, configure the settings and click **Next**.

    | Setting                       | Example Value     |
    | :-                            | :-                |
    | Use the virtual machine name  | Selected          |
    | Domain name                   | sfo.rainpole.io   |

7. On the **Time zone** page, configure the settings and click **Next**.

    | Setting                       | Example Value     |
    | :-                            | :-                |
    | Area                          | America           |
    | Location                      | Los Angeles       |
    | Hardware clock set to         | Local time        |

8. On the **Customization script** page, click **Next**.

9. On the **Network** page, click **Next**.

10. On the **DNS settings** page, leave the default settings, and click **Next**.

11. On the **Ready to complete** page, review the settings and click **Finish**.

12. If you want to add more Linux customization specifications, repeat this procedure for each additional Linux customization specification.

13. Repeat this procedure for each VI workload domain vCenter Server in each VMware Cloud Foundation instance.

#### PowerShell Procedure

1. Start Windows PowerShell.

2. Define the environment variables by running the following commands.

    ```powershell
    $vCenterFqdn = "sfo-w01-vc01.sfo.rainpole.io"
    $vCenterUser = "administrator@vsphere.local"
    $vCenterPass = "VMw@re1!"

    $customizationName = "linux-ubuntu-server-lts"
    $customizationDescription = "Linux Ubuntu server LTS"
    $osType = "Linux"
    $domain = "sfo.rainpole.io"
    $timeZone = "America/Los_Angeles"
    ```

    For a list of the acceptable values for `$TimeZone` for Linux customization specifications, see [List of Time Zone Database Zones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) on Wikipedia or the [IANA Time Zone Database](https://www.iana.org/time-zones).

3. Connect to the VI workload domain vCenter Server and create a customization specification for a Linux guest operating system by running the following VMware PowerCLI cmdlets.

    ```powershell
    Connect-VIServer -Server $vCenterFqdn -User $vCenterUser -Password $vCenterPass

    New-OSCustomizationSpec -Name $customizationName -Description $customizationDescription -OSType $osType  -NamingScheme vm -Domain $domain  

    $CustomizationSpec = Get-View -Id 'CustomizationSpecManager-CustomizationSpecManager'
    $item = $CustomizationSpec.GetCustomizationSpec($customizationName)
    $item.Spec.Identity.HwClockUTC = $false
    $item.Spec.Identity.TimeZone = $timeZone
    $CustomizationSpec.OverwriteCustomizationSpec($item)
    ```

4. View the state of customization specification by running the following command.

    ```powershell
    Get-OSCustomizationSpec -Name $customizationName | Format-List *
    ```

5. Disconnect from the VI workload domain vCenter Server.

    ```powershell
    Disconnect-VIServer -Server $vCenterFqdn -Confirm:$false
    ```

6. If you want to add more Linux customization specifications, repeat this procedure for each additional Linux customization specification.

7. Repeat this procedure for each VI workload domain vCenter Server in each VMware Cloud Foundation instance.

### Create a Customization Specification for Windows Guest Operating Systems

Create a Windows guest operating system specification that you can apply when you create cloud templates for use with vRealize Automation. This customization specification can be used to customize virtual machine guest operating systems when provisioning new virtual machines from vRealize Automation.

#### UI Procedure

1. Log in to vCenter Server at **https://<vcenter\_server\_fqdn>/ui** with a user assigned the **Administrator** role.

2. Select **Menu > Policies and profiles**.

3. In the left pane, click **VM customization specifications**.

4. On the **VM customization specifications** page, click the **Create a new specification** icon.

    The **New VM guest customization** wizard opens.

5. On the **Name and target OS** page, configure the settings and click **Next**.

    | Setting                           | Example Value                 |
    | :-                                | :-                            |
    | Name                              | windows-server-standard       |
    | Description                       | Windows Server Standard       |
    | vCenter Server                    | sfo-w01-vc01.sfo.rainpole.io  |
    | Target guest OS	                | Windows                       |
    | Use custom SysPrep answer file	| Deselected                    |
    | Generate new Security ID (SID)	| Selected                      |

6. On the **Registration information** page, configure the settings and click **Next**.

    | Setting           | Example Value |
    | :-                | :-            |
    | Name              | Rainpole      |
    | Organization      | Rainpole      |

7. On the **Computer name** page, select **Use the virtual machine name**, and click **Next**.

8. On the **Windows license** page, provide licensing information for the Windows operating system, and click **Next**.

9. On the **Administrator password** page, enter the default administrator password to set on the virtual machine, and click **Next**.

10. On the **Time zone** page, select the time zone, and click **Next**.

11. On the **Commands to run once** page, click **Next**.

12. On the **Network** page, click **Next**.

13. On the **Workgroup or domain** page, select **Windows server domain**, enter the name of the Active Directory domain to join, enter the user name and password of service account for domain join operations, and click **Next**.

    | Setting               | Example Value                     |
    | :-                    | :-                                |
    | Windows server domain | sfo.rainpole.io                   |
    | User name             | <svc-domain-join@sfo.rainpole.io> |
    | Password              | *vc-domain-join\password*         |

14. On the **Ready to complete** page, review the settings and click **Finish**.

15. If you want to add more Windows customization specifications, repeat this procedure for each additional Windows customization specification.

16. Repeat this procedure for each VI workload domain vCenter Server in each VMware Cloud Foundation instance.

#### PowerShell Procedure

1. Start Windows PowerShell.

2. Define the environment variables by running the following commands.

    ```powershell
    $vCenterFqdn = "sfo-w01-vc01.sfo.rainpole.io"
    $vCenterUser = "administrator@vsphere.local"
    $vCenterPass = "VMw@re1!"

    $customizationName = "windows-server-standard"
    $customizationDescription = "Windows Server Standard"
    $osType = "Windows"
    $ownerName = "Rainpole"
    $ownerOrganization = "Rainpole"
    $adminPassword = "VMw@re1!"
    $timeZone = "004"
    $domain = "sfo.rainpole.io"
    $domainUser = "svc-domain-join@sfo.rainpole.io"
    $domainPass = "VMw@re1!"
    ```

    For a list of the acceptable values for $TimeZone for Windows customization specifications, see [New-OSCustomizationSpec](https://www.vmware.com/support/developer/windowstoolkit/wintk40u1/html/New-OSCustomizationSpec.html).

3. Connect to the VI workload domain vCenter Server and create a customization specification for a Windows guest operating system by running the following VMware PowerCLI cmdlets.

    ```powershell
    Connect-VIServer -Server $vCenterFqdn -User $vCenterUser -Password $vCenterPass

    New-OSCustomizationSpec -Name $customizationName -Description $customizationDescription -OSType $osType -ChangeSid -FullName $ownerName -OrgName $ownerOrganization -NamingScheme vm -AdminPassword $adminPassword -TimeZone $timeZone -Domain $domain -DomainUsername $domainUser -DomainPassword $domainPass 
    ```

4. View the state of customization specification by running the following command.

    ```powershell
    Connect-VIServer -Server $vCenterFqdn -User $vCenterUser -Password $vCenterPass

    New-OSCustomizationSpec -Name $customizationName -Description $customizationDescription -OSType $osType -ChangeSid -FullName $ownerName -OrgName $ownerOrganization -NamingScheme vm -AdminPassword $adminPassword -TimeZone $timeZone -Domain $domain -DomainUsername $domainUser -DomainPassword $domainPass 
    ```

5. Disconnect from the VI workload domain vCenter Server.

    ```powershell
    Disconnect-VIServer -Server $vCenterFqdn -Confirm:$false
    ```

6. If you want to add more Windows customization specifications, repeat this procedure for each additional Windows customization specification.
    
7. Repeat this procedure for each VI workload domain vCenter Server in each VMware Cloud Foundation instance.
    
[Back: Configure Content Libraries](1-configure-content-libraries.md)

[Next: Configure Mappings in Cloud Assembly](3-configure-mappings.md)