# Configure Mappings in Cloud Assembly

You define deployment sizing and deployment parameters for workloads by using flavor and image mappings in Cloud Assembly.

## Procedure

1. [Add Flavor Mappings in Cloud Assembly](#add-flavor-mappings-in-cloud-assembly)

    You configure flavor mappings for the vCenter Server cloud accounts to define and group a set of target deployment sizings.

2. [Add Image Mappings in Cloud Assembly](#add-image-mappings-in-cloud-assembly)

    You configure image mappings for the vCenter Server cloud accounts to define target deployment operating system and related configuration settings.

### Add Flavor Mappings in Cloud Assembly

You configure flavor mappings for the vCenter Server cloud accounts to define and group a set of target deployment sizings.

You configure flavor mappings to define different deployment sizings.

In the sample, the following flavor mappings are used:

| Name      | Account / Region              | CPU Count | Memory Size   |
| :-        | :-                            | :-        | :-            |
| x-small   | sfo-w01-vc01 / sfo-w01- dc01  | 1         | 1 GB          |
| small     | sfo-w01-vc01 / sfo-w01- dc01  | 2         | 2 GB          |
| medium    | sfo-w01-vc01 / sfo-w01- dc01  | 4         | 8GB           |
| large     | sfo-w01-vc01 / sfo-w01- dc01  | 8         | 16 GB         |
| x-large   | sfo-w01-vc01 / sfo-w01- dc01  | 16        | 32 GB         |

#### UI Procedure

1. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly Administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Cloud Assembly**.

4. Click the **Infrastructure** tab.

5. In the left pane, select **Configure > Flavor mappings**.

6. Click **New flavor mapping** and configure these settings.

    | Setting           | Example Value                 |
    | :-                | :-                            | 
    | Flavor name       | x-small                       |
    | Account / region  | sfo-w01-vc01 / sfo-w01-dc01   |
    | Number of CPUs	| 1                             |
    | Memory (GB)	    | 1                             |

7. If you want to add the flavor mapping for an additional account region, click the **Add item to list** plus icon at the end of the row and configure the settings.

8. Click **Create**

9. Repeat these steps for each of the remaining flavor mappings.

#### Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```powershell
    cd terraform-examples/vra/vra-flavor-mapping
    ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    ```powershell
    cd terraform-examples/vra/vra-flavor-mapping
    ```

3. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

4. If you want to add flavor mappings for additional cloud accounts or regions, repeat steps **2** and **3** for each additional account region by duplicating the example in a different working directory.

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

### Add Image Mappings in Cloud Assembly

You configure image mappings for the vCenter Server cloud accounts to define target deployment operating system and related configuration settings.

You configure image mappings for images in content libraries.

In the sample, the following image mappings are used:

| Name                      | Account / Region              | Content Library / Image                   |
| :-                        | :-                            | :-                                        |
| linux-ubuntu-server-lts   | sfo-w01-vc01 / sfo-w01-dc01   | sfo-w01-lib01 / linux-ubuntu-server-lts   |
| windows-server-standard   | sfo-w01-vc01 / sfo-w01-dc01   | sfo-w01-lib01 / windows-server- standard  |

#### UI Procedure

1. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly Administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Cloud Assembly**.

4. Click the **Infrastructure** tab.

5. In the left pane, select **Configure > Image mappings**.

6. Click **New image mapping**, configure these settings.

    | Setting               | Example Value                             |
    | :-                    | :-                                        |
    | Image name	        | linux-ubuntu-server-lts                   |
    | Account / region      | sfo-w01-vc01 / sfo-w01-dc01               |
    | Image                 | sfo-w01-lib01 / linux-ubuntu-server-lts   |
    | Constraints           | -                                         |
    | Cloud configuration	| -                                         |

7. If you want to add the image mapping for an additional account region, click the **Add item to list** plus icon at the end of the row and configure the settings.

8. Click **Create**.

9. Repeat these steps for each of the remaining image mappings.

#### Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```powershell
    cd terraform-examples/vra/vra-image-mapping
    ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    ```powershell
    cd terraform-examples/vra/vra-flavor-mapping
    ```

3. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

4. If you want to add image mappings for additional cloud accounts or regions, repeat steps **2** and **3** for each additional account region by duplicating the example in a different working directory.

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


[Back: Configure Customization Specifications in vSphere](2-custom-specs.md)

[Next: Configure Profiles in Cloud Assembly](4-configure-profiles.md)
