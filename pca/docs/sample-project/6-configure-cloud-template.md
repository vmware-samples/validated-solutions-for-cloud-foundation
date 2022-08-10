# Configure a Sample Cloud Template in Cloud Assembly

Cloud templates determine the specifications, such as target cloud region, resources, guest operating systems, and others, for the services or applications that consumers of this template can deploy.

## UI Procedure

1. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly Administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Cloud Assembly**.

4. Click the **Design** tab.

5. In the left pane, click **Cloud templates**, and from the **New from** drop-down menu, select **Blank canvas**.

6. In the **New cloud template** dialog box, configure the settings and click **Create**.

    | Setting                                   | Example Value                 |
    | :-                                        | :-                            |
    | Name                                      | Sample Template               |
    | Description                               | Sample Cloud Template         |
    | Project	                                  | Rainpole Sample               |
    | Cloud template sharing in Service Broker  | Share only with this project  |

7. On the **Sample** template design page, in the **Code** tab, enter the following example YAML.

```yaml
name: Sample Template
formatVersion: 1
inputs:
  targetCloud:
    type: string
    oneOf:
      - title: VMware Cloud Foundation
        const: cloud:private
    title: Cloud
    description: Select a target cloud.
  targetRegion:
    type: string
    oneOf:
      - title: sfo-w01-vc01
        const: region:sfo
    title: Region
    description: Select a target region.
  targetEnvironment:
    type: string
    oneOf:
      - title: Production
        const: enabled:true
    title: Environment
    description: Select a target environment.
  targetFunction:
    type: string
    oneOf:
      - title: General Application
        const: function:general
    title: Function
    description: Select a target function.
  performanceTier:
    type: string
    oneOf:
      - title: Platinum
        const: tier:platinum
    title: Performance Tier
    description: Select a performance tier.
  operatingSystem:
    type: string
    oneOf:
      - title: Photon 4.0
        const: photon-4.0
      - title: photon 4.0 (UEFI)
        const: photon-4.0-uefi
    title: Operating System and Version
    description: Select a operating system and version.
  nodeSize:
    type: string
    oneOf:
      - title: X-Small
        const: x-small
      - title: Small
        const: small
      - title: Medium
        const: medium
      - title: Large
        const: large
      - title: X-Large
        const: x-large
    title: Node Size
  nodeCount:
    type: integer
    default: 1
    maximum: 5
    title: Node Count
    description: Select the number of VMs between 1 and 5.
resources:
  Cloud_vSphere_Machine_1:
    type: Cloud.vSphere.Machine
    properties:
      image: ${input.operatingSystem}
      flavor: ${input.nodeSize}
      count: ${input.nodeCount}
      customizationSpec: photon-4.0
      constraints:
        - tag: ${input.targetCloud}
        - tag: ${input.targetRegion}
      networks:
        - network: ${resource.Cloud_NSX_Network_1.id}
          assignment: static
      attachedDisks: []
  Cloud_NSX_Network_1:
    type: Cloud.NSX.Network
    properties:
      networkType: existing
      constraints:
        - tag: ${input.targetEnvironment}
```

8. Test the cloud template.

    a. On the **Sample** template design page, click **Test**.

    b. In the **Testing Sample** dialog box, configure the settings and click **Test**.

    | Setting                       | Example Value             |
    | :-                            | :-                        |
    | Cloud                         | VMware Cloud Foundation   |
    | Region                        | sfo-w01-vc01              |
    | Environment                   | Production                |
    | Function                      | General Application       |
    | Performance Tier              | Platinum                  |
    | Operating System and Version  | Photon 4.0                |
    | Node Size                     | X-Small                   |
    | Node Count                    | 1                         |

    c. Verify that the test finishes successfully.

9.  Version the cloud template.

    a. On the **Sample** template design page, click **Version**.

    b. In the **Creating version** dialog box, configure the settings and click **Create**.

    | Setting                               | Example Value         |
    | :-                                    | :-                    |
    | Version                               | 1.0.0                 |
    | Description                           | Sample Cloud Template |
    | Change log                            | Initial release       |
    | Release this version to the catalog   | Selected              |

    c. On the **Sample** template design page, click **Close**.

#### Terraform Procedure

1. Navigate to the Terraform example in the repository.

    ```bash
    cd terraform-sample-project/11-cloud-assembly-cloud-template
    ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    ```bash
    copy terraform.tfvars.example terraform.tfvars
    ```

3. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

4. Initialize the current directory and the required Terraform providers.

    ```terraform
    terraform init
    ```

5. Create a Terraform plan and save the output to a file.

    ```terraform
    terraform plan -out=tfplan
    ```

6. Apply the Terraform plan.

    ```terraform
    terraform apply tfplan
    ```

7. Test the cloud template by using the UI.

    a. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly Administrator** service role.

    b. On the main navigation bar, click **Services**. 
    
    c. Under **My services**, click **Cloud Assembly**. 
    
    d. Click the **Design** tab.
    
    e. On the **Sample** template design page, click **Test**.

    f. In the **Testing Sample** dialog box, configure the settings and click **Test**.

    | Setting                       | Example Value             |
    | :-                            | :-                        |
    | Cloud                         | Rainpole Private Cloud    |
    | Region                        | San Francisco (US West 1) |
    | Environment                   | Production                |
    | Operating System and Version  | Ubuntu Server LTS         |
    | NSX Network Segments          | On-Demand Routed          |
    | Node Size for Web Tier        | Small                     |
    | Node Count for Web Tier       | 1                         |
    | Node Size for App Tier        | Small                     |
    | Node Count for App Tier       | 1                         |
    | Node Size for Database Tier   | Small                     |

    g. Verify that the test finishes successfully.

[Back: Configure a Sample Project in Cloud Assembly](5-configure-project.md)

[Next: Configure the Project in Service Broker](7-configure-project-service-broker.md)