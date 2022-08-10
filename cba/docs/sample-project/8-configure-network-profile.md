[Back: Home](README.md)

# Configure Network Profiles for Existing Networks

Each network profile is configured for a specific network port group or network segment to specify the IP address and the routing configuration for virtual machines provisioned to that network.

## UI Procedure

1. Log in to the VMware Cloud Services console at **`https://console.cloud.vmware.com`**.

2. On the main navigation bar, click **Services**.

3. Under **My services**, in the **VMware Service Broker** card click **Launch Service**.

4. Click the **Infrastructure** tab.

5. In the left pane, select **Configure > Network profiles**.

6. Click **New network profile**.

7. On the **Summary** tab, configure these settings.

    | Setting           | Example Value                             |
    | :-                | :-                                        |
    | Account / region  | sfo-w01-vc01 / Datacenter:datacenter-3    |
    | Name              | net-existing-sfo-w01-vc01                 |
    | Description       | Existing Networks - Workload Domain 01    |
    | Capability tags   | network:existing                          |

8. Click the **Networks** tab, click **Add network**, select the NSX segments for production and development workloads and click **Add**.

    | Segment                               | Segment Name             |
    | :-                                    | :-                       |
    | NSX segment for production workloads  | sfo-prod-192-168-50-0-24 |
    | NSX segment for development workloads | sfo-dev-192-168-51-0-24  |

9. On the **Networks** tab, for each segment, select the check box, click **Tags**, configure these capability tags, and click **Save**.

    | Segment Name              | Capability Tags  |
    | :-                        | :-               |
    | sfo-prod-192-168-50-0-24	| env:prod         |
    | sfo-dev-192-168-51-0-24	| env:dev          |

10. On the **Networks** tab, for each segment, click the segment name, configure these settings, and click **Save**.

    | Setting               | Example Value for sfo-prod-192-168-50-0-24 | Example Value for sfo-dev-192-168-51-0-24  |
    | :-                    | :-                                        | :-                                        |
    | Domain                | sfo.rainpole.io                           | sfo.rainpole.io                           |
    | IPv4 CIDR             | 192.168.50.0/24                            | 192.168.51.0/24                            |
    | IPv4 default gateway  | 192.168.50.1                               | 192.168.51.1                               |
    | DNS servers           | 172.16.11.4, 172.16.11.5                  | 172.16.11.4, 172.16.11.5                  |
    | DNS search domains    | sfo.rainpole.io                           | sfo.rainpole.io                           |

11. On the **Networks** tab, for each segment, select the check box, click **Manage IP ranges**, click **New IP range**, configure these settings, click **Add**, and click **Close**.

    | Setting               | Example Value for sfo-prod-192-168-50-0-24     | Example Value for sfo-dev-192-168-51-0-24  |
    | :-                    | :-                                            | :-                                        |
    | Source                | Internal                                      | Internal                                  |
    | Name                  | sfo-prod-192-168-50-0-24                       | sfo-dev-192-168-51-0-24                    |
    | Description           | Production: Network Static IP Range           | Development: Network Static IP Range      |
    | Start IP address      | 192.168.50.20                                  | 192.168.51.20                              |
    | End IP address        | 192.168.50.250                                 | 192.168.51.250                             |

12. Click **Create**.

## Terraform

. Navigate to the Terraform example in the repository.

    ```bash
    cd terraform-sample-project/08-cloud-assembly-network-profile
    ```

1. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

   ```bash
   copy terraform.tfvars.example terraform.tfvars
   ```

2. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

3. Initialize the current directory and the required Terraform providers.

   ```terraform
   terraform init
   ```

4. Create a Terraform plan and save the output to a file.

   ```terraform
   terraform plan -out=tfplan
   ```

5. Apply the Terraform plan.

   ```terraform
   terraform apply tfplan
   ```


[Back: Configure Network IP Address Settings for Existing Networks](7-configure-segment-networking.md)

[Next: Configure Storage Profiles in Cloud Assembly](9-configure-storage-profile.md)
