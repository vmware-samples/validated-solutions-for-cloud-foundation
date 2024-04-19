# Release History

## [v2.1.2]

> Release Date: Unreleased

Bugfix:

- Updated artifacts to add vCenter Single Sign-on Ring Topology Health in VMware Aria Operations (Compute dashboard, New Supermetrics, View, Alert/ Notification). [GH-89](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/89)

## [v2.1.1]

> Release Date: 2024-04-04

Bugfix:

- Fixed parsing of SOS Version health data for VxRail Manager VM.
- Updated Artifacts to address incorrect status reported for NSX Backup Health, Supermetrics and Rollup dashboard.

Chore:

- Removed unused files.

## [v2.1.0]

> Release Date: 2024-01-30

Enhancement:

- Added new health checks and updated dashboards to have parity with `VMware.CloudFoundation.Reporting`.
  - ESXi Connection Health table is added to VCF Compute dashboard.
  - Free Pool Health table is added to VCF Compute dashboard.
  - VMs with Connected CD-ROMs table is added to VCF Compute dashboard.
  - VCF Version Health (New Dashboard).
- Updated artifacts - Alerts, Notifications, Supermetrics, Views and Dashboards for new health checks.

Documentation:

- Removed support for VCF version 4.4.
- `Install the Python Module in a Disconnected Environment` section has been added to the `README.md`.
- `Updating the Python Module to the Latest Version` section has been added to the `README.md`.
- Updated Screenshots for new dashboards in the `README.md`.

Chore:

- Updated headers in `.py` files.

## [v2.0.0]

> Release Date: 2023-08-29

Enhancement:

- Added `notifications.py` to create `notifications.json` file from the `notifications-template.json` template.
- Updated artifacts to address changes for use of the VMware Cloud Foundation cloud account.

Chore:

- Code cleanup.
- Remove unused files

## [v1.2.0]

> Release Date: 2023-07-25

Bugfix:

- Update code to handle special characters in passwords for Powershell cmdlets. [GH-62](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/62)

Enhancement:

- Updated format for `Notifications.json` file to make it readable. [GH-61](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/61)

Documentation:

- Updated `README.md` and update version and dist files for release. [GH-61](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/61)

Chore:

- Added `CHANGELOG.md` and removed changelog from `send-data-to-vrops.py` file. [GH-61](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/61)

## [v1.1.0]

> Release Date: 2023-05-30

Bugfix:

- Fixed the date on `Backups and Snapshot` dashboard which was shown incorrectly in previous version [GH-50](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/50)


Enhancement:

- Removed SDDC Manager root password from Python module [GH-38](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/38)
- Updated project structure to host module on PyPI.


Chore:

- Updated views for `Backup and Snapshots` to address issue [GH-50](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/50)
- code cleanup

Documentation:

- Updated `README.md` and update version and dist files for release

## [1.0.0]

> Release Date: 2023-03-28

Bugfix:

- Fixed code to handle exception while sending `Backup Status` data to vROps [GH-48](https://github.com/vmware-samples/validated-solutions-for-cloud-foundation/issues/48)
