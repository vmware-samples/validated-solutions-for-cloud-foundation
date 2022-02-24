# Configure the Project in Service Broker

Enable users to deploy workloads by importing the cloud templates, creating a content source, and sharing the cloud templates within a project in Service Broker.

## Procedure

1. [Configure a Content Source for the Project in Service Broker](#configure-a-content-source-for-the-project-in-service-broker)

    Provide access to vRealize Automation cloud templates to users by creating and configuring a content source for the project in Service Broker.

2. [Share Cloud Templates from a Content Source in Service Broker](#share-cloud-templates-from-a-content-source-in-service-broker)

    You can share cloud templates and content sources within a project to enable project members to deploy these cloud templates in supported cloud zones.

### Configure a Content Source for the Project in Service Broker

Provide access to vRealize Automation cloud templates to users by creating and configuring a content source for the project in Service Broker.

**Important** You cannot create more than one catalog source of the same type from the same project.

#### UI Procedure

1. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Service Broker Administrator** service role.

1. On the main navigation bar, click **Services**.

1. Under **My services**, click **Service Broker**.

1. Click the **Content and policies** tab.

1. In the navigation pane, click **Content sources**.

1. Click **New** and click the **VMware cloud template** card.

1. Configure the settings and click **Validate**.

| Setting           | Example Value             |
| :-                | :-                        |
| Name              | Sample - Cloud Templates  |
| Description       | Sample - Cloud Templates  |
| Source project    | Sample                    |

1. After the successful validation, click **Create and import**.

#### Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```powershell
    cd terraform-examples/vra/vra-content-source
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

### Share Cloud Templates from a Content Source in Service Broker

You can share cloud templates and content sources within a project to enable project members to deploy these cloud templates in supported cloud zones.

#### UI Procedure

1. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Service Broker Administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Service Broker**.

4. Click the **Content and policies** tab.

5. In the navigation pane, click **Content sharing**.

6. In the **Search for a project** text box, select the **Sample** project.

7. Click **Add items**.

8. On the **Share items with Sample** dialog box, from the **Content sources** drop-down menu, select **Content sources**, select the **Sample - Cloud Templates** template, and click **Save**.

#### Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```powershell
    cd terraform-examples/vra/vra-content-item
    ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    ```powershell
    copy terraform.tfvars.example 1terraform.tfvars1
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

[Back: Configure a Sample Cloud Template in Cloud Assembly](6-configure-cloud-template.md)

[Next: Deploy a Sample Cloud Template in Service Broker](8-deploy-cloud-template.md)