# Configure a Sample Cloud Template in Cloud Assembly

Cloud templates determine the specifications, such as target cloud region, resources, guest operating systems, and others, for the services or applications that consumers of this template can deploy.

#### UI Procedure

1. Log in to the vRealize Automation cloud services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Cloud Assembly Administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Cloud Assembly**.

4. Click the **Design** tab.

5. In the left pane, click **Cloud templates**, and from the **New from** drop-down menu, select **Blank canvas**.

6. In the **New cloud template** dialog box, configure the settings and click **Create**.

    | Setting                                   | Example Value                 |
    | :-                                        | :-                            |
    | Name                                      | Sample                        |
    | Description                               | Sample Cloud Template         |
    | Project	                                  | Sample                        |
    | Cloud template sharing in Service Broker  | Share only with this project  |

7. On the **Sample** template design page, in the **Code** tab, enter the following example YAML.

    ```yaml
    name: Sample Cloud Template
    formatVersion: 1
    inputs:
      targetCloud:
        type: string
        oneOf:
          - title: Rainpole Private Cloud
            const: 'cloud:private'
        title: Cloud
        description: |-
          Select a cloud platform:<br/>
          <ul>
            <li>VMware Cloud Foundation</li>
          </ul>
        default: 'cloud:private'
      targetRegion:
        type: string
        oneOf:
          - title: San Francisco (US West 1)
            const: 'region:us-west-1'
          - title: Los Angeles (US West 2)
            const: 'region:us-west-2'
        title: Region
        description: |-
          Select a region:<br/>
          <ul>
            <li>San Francisco, California US (us-west-1)</li>
            <li>Los Angeles, California US (us-west-2)</li>
          </ul>
        default: 'region:us-west-1'
      targetEnvironment:
        type: string
        oneOf:
          - title: Production
            const: 'env:prod'
          - title: Development
            const: 'env:dev'
        title: Environment
        description: |-
          Select an environment:<br/>
          <ul>
            <li>Production</li>
            <li>Development</li>
          </ul>
        default: 'env:prod'
      operatingSystem:
        type: string
        oneOf:
          - title: Ubuntu Server LTS
            const: linux-ubuntu-server-lts
          - title: Microsoft Windows Server Standard
            const: windows-server-standard
        title: Operating System and Version
        description: |-
          Select an operating system and version.:<br/>
          <ul>
            <li>Ubuntu Server LTS</li>
            <li>Microsoft Windows Server Standard</li>
          </ul>
        default: linux-ubuntu-server-lts
      networkType:
        type: string
        oneOf:
          - title: Existing
            const: existing
          - title: On-Demand Routed
            const: routed
        title: NSX Network Segments
        description: |-
          Select an NSX segment type:<br/>
          <ul>
            <li>Existing NSX Segments</li>
            <li>On-Demand Routed NSX Segments</li>
          </ul>
        default: routed
      webNodeSize:
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
        title: Node Size for Web Tier
        description: |-
          Select the size for the node:<br/>
          <ul>
            <li><strong>X-Small</strong>: 1 vCPU x 1 GB Memory</li>
            <li><strong>Small</strong>: 2 vCPU x 2 GB Memory</li>
            <li><strong>Medium</strong>: 4 vCPU x 8 GB Memory</li>
            <li><strong>Large</strong>: 8 vCPU x 16 GB Memory</li>
            <li><strong>X-Large</strong>: 16 vCPU x 32 GB Memory</li>
          </ul>
        default: small
      webNodeCount:
        type: integer
        maximum: 10
        title: Node Count for Web Tier
        description: Select the number of VMs between 1 and 10.
        default: 1
      appNodeSize:
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
        title: Node Size for Application Tier
        description: |-
          Select the size for the node:<br/>
          <ul>
            <li><strong>X-Small</strong>: 1 vCPU x 1 GB Memory</li>
            <li><strong>Small</strong>: 2 vCPU x 2 GB Memory</li>
            <li><strong>Medium</strong>: 4 vCPU x 8 GB Memory</li>
            <li><strong>Large</strong>: 8 vCPU x 16 GB Memory</li>
            <li><strong>X-Large</strong>: 16 vCPU x 32 GB Memory</li>
          </ul>
        default: small
      appNodeCount:
        type: integer
        maximum: 10
        title: Node Count for App Tier
        description: Select the number of VMs between 1 and 10.
        default: 1
      dbNodeSize:
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
        title: Node Size for Database Tier
        description: |-
          Select the size for the node:<br/>
          <ul>
            <li><strong>X-Small</strong>: 1 vCPU x 1 GB Memory</li>
            <li><strong>Small</strong>: 2 vCPU x 2 GB Memory</li>
            <li><strong>Medium</strong>: 4 vCPU x 8 GB Memory</li>
            <li><strong>Large</strong>: 8 vCPU x 16 GB Memory</li>
            <li><strong>X-Large</strong>: 16 vCPU x 32 GB Memory</li>
          </ul>
        default: small
    resources:
      web:
        type: Cloud.vSphere.Machine
        properties:
          image: '${input.operatingSystem}'
          flavor: '${input.webNodeSize}'
          count: '${input.webNodeCount}'
          customizationSpec: '${input.operatingSystem}'
          networks:
            - network: '${resource.network.id}'
              assignment: static
          tags:
            - key: function
              value: web
          constraints:
            - tag: '${input.targetCloud}'
            - tag: '${input.targetRegion}'
      app:
        type: Cloud.vSphere.Machine
        properties:
          image: '${input.operatingSystem}'
          flavor: '${input.appNodeSize}'
          count: '${input.appNodeCount}'
          customizationSpec: '${input.operatingSystem}'
          networks:
            - network: '${resource.network.id}'
              assignment: static
          tags:
            - key: function
              value: app
          constraints:
            - tag: '${input.targetCloud}'
            - tag: '${input.targetRegion}'
      db:
        type: Cloud.vSphere.Machine
        properties:
          image: '${input.operatingSystem}'
          flavor: '${input.dbNodeSize}'
          customizationSpec: '${input.operatingSystem}'
          networks:
            - network: '${resource.network.id}'
              assignment: static
          tags:
            - key: function
              value: db
          constraints:
            - tag: '${input.targetCloud}'
            - tag: '${input.targetRegion}'
      network:
        type: Cloud.NSX.Network
        properties:
          networkType: '${input.networkType}'
          constraints:
            - tag: '${input.targetEnvironment}'
            - tag: '${input.networkType == "routed" ? "network:ondemand" : (input.networkType == "existing" ? "network:existing" : "network:ondemand")}'
    ```

8. Test the cloud template.

    a. On the **Sample** template design page, click **Test**.

    b. In the **Testing Sample** dialog box, configure the settings and click **Test**.

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

    c. Verify that the test finishes successfully.

12. Version the cloud template.

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

    ```powershell
    cd terraform-examples/vra/vra-cloud-template
    ```

2. Duplicate the `terraform.tfvars.example` file to `terraform.tfvars` in the directory.

    ```powershell
    copy terraform.tfvars.example terraform.tfvars
    ```

3. Open the `terraform.tfvars` file, update the variables for your environment, and save the file.

4. Initialize the current directory and the required Terraform providers.

5. Create a Terraform plan and save the output to a file.

    ```powershell
    terraform plan -out=tfplan
    ```

6. Apply the Terraform plan.

    ```powershell
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