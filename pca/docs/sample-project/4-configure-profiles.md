# Configure Profiles in Cloud Assembly

You define target networks and datastores for workload provisioning by using network and storage profiles in Cloud Assembly.

## Procedure

1. [Configure Network Profiles for Existing Networks](#configure-network-profiles-for-existing-networks)

    Each network profile is configured for a specific network port group or virtual network segment to specify the IP address and the routing configuration for virtual machines provisioned to that network.

2. [Configure Network Profiles for On-Demand Networks](#configure-network-profiles-for-on-demand-networks)

3. [Configure Storage Profiles in Cloud Assembly](#configure-storage-profiles-in-cloud-assembly)

    You configure type of storage for the provisioned workloads by defining a storage profile in Cloud Assembly for the specific cloud account and region.

### Configure Network Profiles for Existing Networks

Each network profile is configured for a specific network port group or virtual network segment to specify the IP address and the routing configuration for virtual machines provisioned to that network.

#### Add NSX Segments in NSX-T Data Center for Use of Existing Networks in vRealize Automation

Before project members can request workloads on existing networks, you must add the network segments from the VI workload domain NSX Local Manager to the network profiles defined in vRealize Automation. You configure separate segments for the environment type and application tier.

NSX Segments for Existing Networks

| Setting           | Example Value for Production Workloads    | Example Value for Development Workloads   |
| :-                | :-                                        | :-                                        |
| Segment name      | sfo-prod-172-11-10-0-24                   | sfo-dev-172-12-10-0-24                    |
| Connected gateway | sfo-w01-ec01-t1-gw01                      | sfo-w01-ec01-t1-gw01                      |
| Transport zone    | overlay-tz-sfo-w01-nsx01.sfo.rainpole.io  | overlay-tz-sfo-w01-nsx01.sfo.rainpole.io  |
| Subnets           | 172.11.10.1/24                            | 172.12.10.1/24                            |

##### UI Procedure

1. Log in to the NSX Local Manager cluster for the VI workload domain at **`https://<vi_workload_nsx_local_manager_fqdn>/login.jsp?local=true`** as **admin**.

2. On the main navigation bar, click **Networking**.

3. In the navigation pane, under **Connectivity**, click **Segments**.

4. On the **Segments** tab, click **Add segment**, configure these settings and click **Save**.

    | Setting                     | Example Value                             |
    | :-                          | :-                                        |
    | Segment name                | sfo-prod-172-11-10-0-24                   |
    | Connected gateway           | sfo-w01-ec01-t1-gw01                      |
    | Transport zone              | overlay-tz-sfo-w01-nsx01.sfo.rainpole.io  |
    | Subnets (Gateway CIDR IPv4) | 172.11.10.1/24                            |
    | Admin state                 | Turned on                                 |

5. In the **Want to continue configuring this Segment?** dialog box, click **No**.

6. Repeat this procedure for the NSX segment for development workloads.

7. Repeat this procedure for each NSX segment for use of existing networks for each VI workload domain across the VMware Cloud Foundation instances.

##### Terraform Procedure

1. Navigate to the Terraform example in the repository.

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    ```powershell
    cd terraform-examples/nsxt/nsx-segments-existing
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

7. Repeat this procedure for the NSX segments for use of existing networks for each VI workload domain across the VMware Cloud Foundation instances by duplicating the originating directory contents from the example to a different working directory.

    **Results**

    When the resource collection finishes, the NSX segments are available for the NSX-T Manager cloud account. The resource collection for cloud accounts runs automatically every 10 minutes.

#### Emable Network Profiles for Existing Networks

Each network profile is configured for a specific network port group or network segment to specify the IP address and the routing configuration for virtual machines provisioned to that network.

##### UI Procedure

1. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly Administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Cloud Assembly**.

4. Click the **Infrastructure** tab.

5. In the left pane, select **Configure > Network profiles**.

6. Click **New network profile**.

    The **New network profile** page opens.

7. On the **Summary** tab, configure these settings.

    | Setting           | Example Value                             |
    | :-                | :-                                        |
    | Account / region  | sfo-w01-vc01 / sfo-w01-dc01               |
    | Name              | net-existing-sfo-w01-vc01                 |
    | Description       | Existing Networks - Workload Domain 01    |
    | Capability tags   | network:existing                          |

8. Click the **Networks** tab, click **Add network**, select the NSX segments for production and development workloads and click **Add**.

    | Segment                               | Segment Name              |
    | :-                                    | :-                        |
    | NSX segment for production workloads  | sfo-prod-172-11-10-0-24   |
    | NSX segment for development workloads | sfo-dev-172-12-10-0-24    |

9. On the **Networks** tab, for each segment, select the check box, click **Tags**, configure these capability tags, and click **Save**.

    | Segment Name              | Capability Tags  |
    | :-                        | :-               |
    | sfo-prod-172-11-10-0-24	| env:prod         |
    | sfo-dev-172-12-10-0-24	| env:dev          |

10. On the **Networks** tab, for each segment, click the segment name, configure these settings, and click **Save**.

    | Setting               | Example Value for sfo-prod-172-11-10-0-24 | Example Value for sfo-dev-172-12-10-0-24  |
    | :-                    | :-                                        | :-                                        |
    | Domain                | sfo.rainpole.io                           | sfo.rainpole.io                           |
    | IPv4 CIDR             | 172.11.10.0/24                            | 172.12.10.0/24                            |
    | IPv4 default gateway  | 172.11.10.1                               | 172.12.10.1                               |
    | DNS servers           | 172.16.11.4, 172.16.11.5                  | 172.16.11.4, 172.16.11.5                  |
    | DNS search domains    | sfo.rainpole.io                           | sfo.rainpole.io                           |

11. On the **Networks** tab, for each segment, select the check box, click **Manage IP ranges**, click **New IP range**, configure these settings, click **Add**, and click **Close**.

    | Setting               | Example Value for sfo-prod-172-11-10-0-24     | Example Value for sfo-dev-172-12-10-0-24  |
    | :-                    | :-                                            | :-                                        |
    | Source                | Internal                                      | Internal                                  |
    | Name                  | sfo-prod-172-11-10-0-24                       | sfo-dev-172-12-10-0-24                    |
    | Description           | Production: Network Static IP Range           | Development: Network Static IP Range      |
    | Start IP address      | 172.11.10.20                                  | 172.12.10.20                              |
    | End IP address        | 172.11.10.250                                 | 172.12.10.250                             |

12. Click **Create**.

13. Repeat this procedure to create network profiles for additional accounts and regions across the VMware Cloud Foundation instances.

##### Terraform / UI Procedure

1. Create the network profile by using Terraform.

    a. Navigate to the Terraform example in the repository.

    b. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    c. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

    d. If you want to add multiple network profiles in the cloud account or in additional cloud accounts, repeat steps **1.b** and **1.c** for each additional cloud account by duplicating the example in a different working directory.

    e. Initialize the current directory and the required Terraform providers.

    f. Create a Terraform plan and save the output to a file.

    g. Apply the Terraform plan.

2. Apply the capability tags by using the UI.

    a. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly Administrator** service role.

    b. On the main navigation bar, click **Services**. 
    
    c. Under **My services**, click **Cloud Assembly**. 
    
    d. Click the **Infrastructure** tab.

    e. In the left pane, select **Configure > Network profiles**. 
    
    f. In the **net-existing-sfo-w01-vc01-01** card, click **Open**.

    g. On the **Summary** tab, configure the following value.

    | Setting           | Example Value     |
    | :-                | :-                |
    | Capability tags	| network:existing  |    

    h. Click the **Networks** tab and for each segment, select the check-box, click **Tags**, configure these capability tags, and click **Save**.

    | Segment Name              | Capability Tags   |
    | :-                        | :-                |
    | sfo-prod-172-11-10-0-24   | env:prod          |
    | sfo-dev-172-12-10-0-24    | env:dev           |

3. Obtain the UUID of each NSX segment, `UUID_of_sfo-prod-172-11-10-0-24` and `UUID_of_sfo-dev-172-12-10-0-24`, by using the UI.

    a. In the left pane, select **Resources > Networks**.

    b. For each segment, click the network name and, from the URL in the Web browser, copy the value after edit%2F.

    For example, in the `https://xint-vra01.rainpole.io/automation-ui/#/provisioning-ui;ash=%2Fnetwork%2Fsubnets%2Fedit%2Fb3c69351-3db1-41dd-bfba-3c2de71fbe4f` URL, the UUID is `b3c69351-3db1-41dd-bfba-3c2de71fbe4f`.

4. Configure the network settings by using Terraform.

    a. Navigate to the Terraform example in the repository.

    ```powershell
    cd terraform-examples/vra/vra-fabric-network-existing
    ```

    b. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    ```powershell
    copy terraform.tfvars.example terraform.tfvars
    ```

    c. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

    d. Initialize the current directory and the required Terraform providers.

    ```powershell
    terraform init
    ```

    e. Import the networks into the Terraform state by using the UUIDs that you obtained in step [3]().

    ```powershell
    terraform import vra_fabric_network_vsphere.network0 UUID_of_sfo-prod-172-11-10-0-24
    terraform import vra_fabric_network_vsphere.network1 UUID_of_sfo-dev-172-12-10-0-24
    ```

    f. Create a Terraform plan and save the output to a file.

    ```powershell
    terraform plan -out=tfplan
    ```

    g. Apply the Terraform plan.

    ```powershell
    terraform apply tfplan
    ```

### Configure Network Profiles for On-Demand Networks

#### Add NSX Segments for Use of On-Demand Networks and in vRealize Automation

Before project members can request workloads using on-demand networks, you must add a network segment to the VI workload domain NSX Local Manager to the network profiles defined in vRealize Automation. In this sample, you configure one segment for on-demand networks.

##### UI Procedure

1. Log in to the NSX Local Manager cluster for the VI workload domain at **`https://<vi_workload_nsx_local_manager_fqdn>/login.jsp?local=true`** as **admin**.

2. On the main navigation bar, click **Networking**.

3. In the navigation pane, under **Connectivity**, click **Segments**.

4. On the **Segments** tab, click **Add segment**, configure these values and click **Save**.

    | Setting                       | Example Value                             |
    | :-                            | :-                                        |
    | Segment name                  | sfo-outbound-192-168-64-0-22              |
    | Connected gateway             | sfo-w01-ec01-t1-gw01                      |
    | Transport zone	            | overlay-tz-sfo-w01-nsx01.sfo.rainpole.io  |
    | Subnets (Gateway CIDR IPv4)	| 192.168.64.1/22                           |
    | Admin state	                | Turned on                                 |

5. In the **Want to continue configuring this Segment?** dialog box, click **No**.

6. Repeat this procedure for each NSX segment for use of on-demand networks for each VI workload domain across the VMware Cloud Foundation instances.

##### Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```powershell
    cd terraform-examples/nsxt/nsx-segments-ondemand
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

7. Repeat this procedure for the NSX segments for use of on-demand networks for each VI workload domain across the VMware Cloud Foundation instances by duplicating the originating directory contents from the example to a different working directory.

    **Results**

    When the resource collection finishes, the NSX segments are available for the NSX-T Manager cloud account. The resource collection for cloud accounts runs automatically every 10 minutes.

#### Configure Network Profiles for On-Demand Networks

Each network profile is configured for a specific network port group or virtual network segment to specify the IP address and the routing configuration for virtual machines provisioned to that network.

##### UI Procedure

1. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly Administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Cloud Assembly**.

4. Click the **Infrastructure** tab.

5. In the left pane, select **Configure > Network profiles**.

6. Click **New network profile**.

    The **New network profile** page opens.

7. On the **Summary** tab, configure these settings.

    | Setting           | Example Value                             |
    | :-                | :-                                        |
    | Account / region	| sfo-w01-vc01 / sfo-w01-dc01               |
    | Name	            | net-ondemand-sfo-w01-vc01                 |
    | Description	    | On-Demand Networks - Workload Domain 01   |
    | Capability tags   | network:ondemand                          |
    |                   | env:prod                                  |
    |                   | env:dev                                   |

8. Click the **Networks** tab, click **Add network**, select the segment for on-demand networks, **sfo-outbound-192-168-64-0-22**, and click **Add**.

9. On the **Networks** tab, click the segment name, **sfo-outbound-192-168-64-0-22**, configure these settings, and click **Save**.

    | Setting               | Example Value                 |
    | :-                    | :-                            |
    | Network domain        | sfo-outbound-192-168-64-0-22  |
    | Domain                | sfo.rainpole.io               |
    | IPv4 CIDR             | 192.168.64.0/22               |
    | IPv4 default gateway  | 192.168.64.1                  |
    | DNS servers           | 172.16.11.4, 172.16.11.5      |
    | DNS search domains    | sfo.rainpole.io               |

10. On the **Networks** tab, select the segment check-box, **sfo-outbound-192-168-64-0-22**, click **Manage IP ranges**, click **New IP range**, configure these settings, click **Add**, and click **Close**.

    | Setting               | Example Value                         |
    | :-                    | :-                                    |
    | Source	            | Internal                              |
    | Name                  | sfo-outbound-192-168-64-0-22          |
    | Description           | On-Demand: Network Static IP Range    |
    | Start IP address      | 192.168.64.20                         |
    | End IP address	    | 192.168.67.250                        |

11. Click the **Network policies** tab and configure these settings.

    | Setting               | Example Value                             |
    | :-                    | :-                                        |
    | Isolation policy      | On-demand network                         |
    | Transport zone        | overlay-tz-sfo-w01-nsx01.sfo.rainpole.io  |
    | External network      | sfo-outbound-192-168-64-0-22              |
    | Tier-0 logical router | sfo-w01-ec01-t0-gw01                      |
    | Edge cluster          | sfo-w01-ec01                              |
    | Source                | Internal                                  |
    | CIDR                  | 192.168.128.0/18 (16382 IPv4 addresses)   |
    |                       | **Note** The network address range must be large enough to create multiple isolated subnets in a deployment during provisioning.|
    | Subnet size           | /28 (~14 IP addresses)                    |
    | IP range assignment   | Static                                    |

12. Click **Create**.

13. Repeat this procedure to create network profiles for additional accounts and regions across the VMware Cloud Foundation instances.

##### Terraform / UI Procedure

1. Create the network profile by using Terraform.

    a. Navigate to the Terraform example in the repository.

    b. Duplicate the terraform.tfvars.example file to terraform.tfvars in the directory.

    c. Open the terraform.tfvars file, update the variables for your environment, and save the file.

    d. If you want to add multiple network profiles in the cloud account or in additional cloud accounts, repeat steps [1.b](#_bookmark83) and [1.c](#_bookmark84) for each additional cloud account by duplicating the example in a different working directory.

    e. Initialize the current directory and the required Terraform providers.

    f. Create a Terraform plan and save the output to a file.

    g. Apply the Terraform plan.

2. Apply the capability tags by using the UI.

    a. Log in to the vRealize Automation cloud services console at **https://****<vra\_cluster\_fqdn>/csp/gateway/portal** with a user assigned the **Cloud Assembly administrator** service role.

    b. On the main navigation bar, click **Services**. 
    
    c. Under **My services**, click **Cloud Assembly**. 
    
    d. Click the **Infrastructure** tab.

    e. In the left pane, select **Configure > Network profiles**. 
    
    f. In the **net-ondemand-sfo-w01-vc01** card, click **Open**.

    g. On the **Summary** tab, configure the following values and click **Save**.

    | Setting            | Example Value    |
    | :-                 | :-               |
    | Capability tags	 | network:ondemand |
    |                    | env:prod         |
    |                    | env:dev          |

    h. Click **Save**.

3. Obtain the UUID of the NSX segment, `UUID_of_sfo-outbound-192-168-64-0-22`, by using the UI.

    a. In the left pane, select **Resources > Networks**.

    b. Click the network name, **sfo-outbound-192-168-64-0-22**, and from the URL in the Web browser, copy the value after `edit%2F`.

    For example, if the URL is `https://xint-vra01.rainpole.io/automation-ui/#/ provisioning-ui;ash=%2Fnetwork%2Fsubnets%2Fedit%2Fb3c69351-3db1-41dd- bfba-3c2de71fbe4f`, the UUID is `b3c69351-3db1-41dd-bfba-3c2de71fbe4f`.

4. Configure the network settings by using Terraform.

    a. Navigate to the Terraform example in the repository.

    b. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    c. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

    d. Initialize the current directory and the required Terraform providers.

    e. Import the network into the Terraform state by using the UUID that you obtained in step [3]().

    f. Create a Terraform plan and save the output to a file.

    g. Apply the Terraform plan.

5. Configure the NSX Tier-0 gateway and the NSX Edge cluster on the network profile by using the UI.

    a. Back in the vRealize Automation cloud services console, in the left pane, select **Configure > Network profiles**.

    b. In the **net-ondemand-sfo-w01-vc01** card, click **Open**.

    c. Click the **Network policies** tab, configure these settings, and click **Save**.

    | Setting               | Example Value         |
    | :-                    | :-                    |
    | Tier-0 logical router | sfo-w01-ec01-t0-gw01  |
    | Edge cluster          | sfo-w01-ec01          |

#### Configure Storage Profiles in Cloud Assembly

You configure type of storage for the provisioned workloads by defining a storage profile in Cloud Assembly for the specific cloud account and region.

##### UI Procedure

1. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Cloud Assembly**.

4. Click the **Infrastructure** tab.

5. In the left pane, select **Configure > Storage profiles**.

6. On the **Storage profiles** page, click **New storage profile**, configure the settings, and click **Create**.

    | Setting                               | Example Value                         |
    | :-                                    | :-                                    |
    | Account / region                      | sfo-w01-vc01 / sfo-w01-dc01.          |
    | Name                                  | standard-sfo-w01-cl01-vsan-default.   |
    | Description	                        | standard-sfo-w01-cl01-vsan-default.   |
    | Disk type	                            | Standard disk                         |
    | Storage policy	                    | sfo-w01-cl01 vSAN Storage Policy.     |
    | Datastore / cluster	                | sfo-w01-cl01-ds-vsan01.               |
    | Provisioning type	                    | Thin                                  |
    | Shares	                            | Unspecified                           |
    | Limit IOPS	                        | -                                     |
    | Disk mode	                            | Dependent                             |
    | Preferred storage for this region	    | Selected                              |
    | Capability tags                       | tier:platinum                         |

7. Repeat this procedure for each storage profile that you want to add for the account region.

8. Repeat this procedure for each storage profile that you want to add for each additional account region across the VMware Cloud Foundation instances.

##### Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```powershell
    cd terraform-examples/vra/vra-storage-profile
    ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    ```powershell
    copy terraform.tfvars.example terraform.tfvars
    ```

3. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

4. If you want to add storage profiles for additional cloud accounts, repeat steps **2** and **3** for each additional cloud account by duplicating the example in a different working directory.

5. Initialize the current directory and the required Terraform providers.

    ```powershell
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

[Back: Configure Mappings in Cloud Assembly](3-configure-mappings.md)

[Next: Configure a Sample Project in Cloud Assembly](5-configure-project.md)
