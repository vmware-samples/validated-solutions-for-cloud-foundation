![Rainpole](../images/icon-rainpole.png)

# Configure a Sample Project in vRealize Automation

After completing the vRealize Automation implementation, optionally, you can configure a sample project scenario to test the workload provisioning.

You prepare for workload provisioning by allocating the necessary infrastructure resources by using flavor mappings, image mappings, network profiles, and storage profiles. You can configure a sample project, content library, and a sample cloud templates to test the sharing of workload provisioning capabilities with the cloud infrastructure consumers in your organization.

## Prerequisites

Synchronize the following Active Directory groups into Workspace ONE Access. See [Synchronize the Groups for vRealize Automation from the Identity Provider into Workspace ONE Access](https://docs.vmware.com/en/VMware-Cloud-Foundation/services/vcf-private-cloud-automation-v1/GUID-393E66A3-AB9E-49F1-9229-198A38979F96.html#GUID-393E66A3-AB9E-49F1-9229-198A38979F96).

| Security Group Name             | Security Group Description                                                                            |
| :-                              | :-                                                                                                    |
| `gg-vra-project-admins-sample`  | An Active Directory security group for the administrators of the sample vRealize Automation project.  |
| `gg-vra-project-users-sample`   | An Active Directory security group for the members of the sample vRealize Automation project.         |

## Procedures

Procedures are provided using the user interfaces as well as the use of PowerShell and/or Terraform, where applicable.

1. [Configure Content Libraries in vSphere](1-configure-content-libraries.md)

   Content libraries are containers for VM templates, vApp templates, and other resources used for vRealize Automation deployment of virtual machines and vApps. Sharing templates and files across multiple vCenter Server instances brings out consistency, compliance, efficiency, and automation in deploying workloads at scale.

2. [Configure Customization Specifications in vSphere](2-configure-custom-specs.md)

   Create customization specifications, one for Linux and one for Windows, for use by the virtual machines images you deploy. Customization specifications are XML files that contain system configuration settings for the guest operating systems used in the virtual machines. You can use the customization specifications when you create cloud templates in vRealize Automation.

3. [Configure Mappings in Cloud Assembly](3-configure-mappings.md)

   You define deployment sizing and deployment parameters for workloads by using flavor and image mappings in Cloud Assembly.

4. [Configure Profiles in Cloud Assembly](4-configure-profiles.md)

   You define target networks and datastores for workload provisioning by using network and storage profiles in Cloud Assembly.

5. [Configure a Sample Project in Cloud Assembly](5-configure-project.md)

   You configure a project to define the users that can provision workloads, the priority and cloud zone of deployments, and the maximum allowed deployment instances.

6. [Configure a Sample Cloud Template in Cloud Assembly](6-configure-cloud-template.md)

   Cloud templates determine the specifications, such as target cloud region, resources, guest operating systems, and others, for the services or applications that consumers of this template can deploy.

7. [Configure the Project in Service Broker](7-configure-project-service-broker.md)

   Enable users to deploy workloads by importing the cloud templates, creating a content source, and sharing the cloud templates within a project in Service Broker.

8. [Deploy a Sample Cloud Template in Service Broker](8-deploy-cloud-template.md)

   After you import the cloud template and share it with members of your project, you test the provisioning by requesting a deployment.