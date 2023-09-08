# Deploy a Sample Cloud Template in Service Broker

After you import the cloud template and share it with members of your project, you test the provisioning by requesting a deployment.

## Procedure

1. Log in to the Aria Automation services console at **`https://<vra_fqdn>/csp/gateway/portal`** with a user assigned the **Service Broker Administrator** service role.

2. On the main navigation bar, click **Services**.

3. Under **My services**, click **Service Broker**.

4. On the **Catalog** tab, in the **Sample** card, click **Request**.

5. On the **New request** page, configure the settings and click **Submit**.

    | Setting                       | Example Value             |
    | :-                            | :-                        |
    | Version                       | 1.0.0                     |
    | Project                       | Sample                    |
    | Deployment name               | Sample Deployment         |
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

6. Verify that the deployment completed successfully.

    a. Click the **Deployments** tab and click the **Sample Deployment** card.

    b. Click the **History** tab and click the **Request details** tab.

7. Verify that the table shows the applied cloud template constraint tags.

8. When the deployment completes, verify that the deployment card has the Create successful tag.

![Skylar is happy!](../images/illustration-success.png)
