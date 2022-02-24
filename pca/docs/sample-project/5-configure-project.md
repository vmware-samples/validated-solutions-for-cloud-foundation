# Configure a Sample Project in Cloud Assembly

You configure a project to define the users that can provision workloads, the priority and cloud zone of deployments, and the maximum allowed deployment instances.

#### UI Procedure

1. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly Administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Cloud Assembly**.

4. Click the **Infrastructure** tab.

5. In the left pane, select **Administration > Projects**.

6. Click **New project**.

7. On the **Summary** tab, configure the settings.

    | Setting       | Example Value     |
    | :-            | :-                |
    | Name          | Sample            |
    | Description   | Sample Project    |

8. Click the **Users** tab, and for each group, click **Add groups**, configure these settings, and click **Add**.

    | Setting       | Example Value for Project Administrators  | Example Value for Project Users   |
    | :-            | :-                                        | :-                                |
    | Group         | gg-vra-project-admins-sample              | gg-vra-project-users-sample       |
    | Assign role   | Administrator                             | Member                            |

9. Click the **Provisioning** tab and, from the **Add zone** drop-down menu, select **Cloud zone**.

10. Configure these settings, and click **Add**.

    | Setting               | Example Value                 |
    | :-                    | :-                            |
    | Cloud zone            | sfo-w01-vc01 / sfo-w01-dc01   |
    | Provisioning priority | 1                             |
    | Instances limit       | 0                             |
    | Memory limit (GB)     | 0                             |
    | CPU limit             | 0                             |
    | Storage limit(GB)     | 0                             |

11. If you want to add more cloud zones to the project, repeat step **10** for each additional cloud zone.

12. On the **Provisioning** tab, under **Custom naming**, in the **Template** text box, enter the naming template for the machines in this project, **`${project.name}-${resource.name}${###}`**.

    Object naming will appear similar to `sample-web123`.

13. Click **Create**.

14. If you want to create more projects, repeat the procedure for each additional project.

#### Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```powershell
    cd terraform-examples/vra/vra-project
    ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    ```powershell
    copy terraform.tfvars.example terraform.tfvars
    ```

3. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

    You can assign multiple cloud zones by updating the `project_zones` object map with additional cloud zones.

4. If you want to create multiple projects, repeat steps [2]() and [3]() for each additional project by duplicating the example in a different working directory.

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

[Back: Configure Profiles in Cloud Assembly](4-configure-profiles.md)

[Next: Configure a Sample Cloud Template in Cloud Assembly](6-configure-cloud-template.md)
