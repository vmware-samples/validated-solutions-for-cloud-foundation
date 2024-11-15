# Private Cloud Maturity Model Dashboards in VMware Aria Operations

## Introduction

This content supports the Private Cloud Maturity Model which enables the user to monitor the state of your journey with [VMware Cloud Foundation](https://docs.vmware.com/en/VMware-Cloud-Foundation) through custom dashboards and alerts.

## Requirements

### Platforms

- VMware Cloud Foundation 5.2
- VMware Cloud Foundation 5.1
- VMware Cloud Foundation 5.0
- VMware Cloud Foundation 4.5

## Implementation

1. Log in to the VMware Aria Operations interface at **`https://<aria_operations_fqdn>`** with a
   user assigned the **Administrator** role.
2. Import the pre-defined super metrics.
   1. In the left pane, navigate to **Operations** > **Configuration**.
   2. On the **Configuration** page, click **Super Metrics**.
   3. From the ellipsis drop-down menu, select **Import**.
   4. In the **Import Super Metric** dialog box, click **Browse**, navigate to the
      `Supermetrics.json` file, click **Open**, click - **Import**, and click **Done**.
   5. Configure the default policy to enable the super metrics.
   6. In the left pane, navigate to **Operations** > **Configurations**.
   7. On the **Configuration** page, click **Policy Definitions**.
   8. On the **Policy Definition** page, select the **Default Policy** and, from the ellipsis
      drop-down menu, select **Edit**.
   9. On the **Default Policy** page, click the **Metrics and Properties** card.
   10. From the **Select Object Type** drop-down menu, select **vCenter** > **Cluster Compute
       Resource**.
   11. Expand **Super Metrics** and select all super metrics beginning with `SM`.
   12. From the **Actions** drop-down menu, select **State** > **Activate**.
   13. On the **Metrics and Properties** page, click **Save**.
   14. Repeat this step to activate these **Object Type**s:
     - Cluster computer resource
     - CAS Adapter Instance
     - Universe
     - LoginSight Adapter Instance
3. Import the pre-defined dashboards.
   1. In the left pane, navigate to **Operations** > **Dashboards**.
   2. In the **Dashboards** pane, click **Manage**.
   3. From the ellipsis drop-down menu, select **Import**.
   4. In the **Import Dashboard** dialog box, click **Browse**, navigate to the `Dashboards.json`
      file, click **Open**, click **Import**, and click **Done**.

## Support

We welcome you to use the
[GitHub Issues](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues)
to report bugs or suggest enhancements.

In order to have a good experience with our community, we recommend that you read the
[contributing guidelines](../CONTRIBUTING.md).

When filing an issue, please check existing open, or recently closed, issues to make sure someone
else hasn't already reported the issue.

Please try to include as much information as you can. Details like these are incredibly useful:

- A reproducible test case or series of steps.
- Any modifications you've made relevant to the bug.
- Anything unusual about your environment or deployment.

## License

© Broadcom. All Rights Reserved.
The term “Broadcom” refers to Broadcom Inc. and/or its subsidiaries.

Licensed under the BSD 2-Clause license.
