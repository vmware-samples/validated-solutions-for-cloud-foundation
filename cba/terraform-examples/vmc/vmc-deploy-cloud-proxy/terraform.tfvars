##################################################################################
# VARIABLES
##################################################################################

# vSphere Settings

vsphere_server     = "sfo-m01-vc01.sfo.rainpole.io"
vsphere_username   = "administrator@vsphere.local"
vsphere_password   = "VMw@re1!"
vsphere_insecure   = false
vsphere_host       = "sfo01-m01-esx01.sfo.rainpole.io"
vsphere_datacenter = "sfo-m01-dc01"
vsphere_folder     = "sfo-m01-fd-vmc"
vsphere_cluster    = "sfo-m01-cl01"
vsphere_datastore  = "sfo-m01-cl01-ds-vsan01"
vsphere_network    = "sfo01-m01-cl01-vds01-pg-mgmt"

# Cloud Proxy Settings

cloud_proxy_ovf_remote                = "https://ci-data-collector.s3.amazonaws.com/VMware-Cloud-Services-Data-Collector.ova"
cloud_proxy_ovf_local                 = null
cloud_proxy_otk                       = "eyJyZWdpc3RyYXRpb25VcmwiOiJodHRwczovL2FwaS5zdGFnaW5nLnN5bXBob255LWRldi5jb20vZWFhOWQ5ZjctYjg5Zi00ZWE4LWIwODktZGU3ZTg1ZTYyMDZjIiwib3RrIjoiQkFPUi03UTcyLUhMQVotTExaWSIsInRlbmFudElkIjoiL3RlbmFudHMvb3JnYW5pemF0aW9uL2VhYTlkOWY3LWI4OWYtNGVhOC1iMDg5LWRlN2U4NWU2MjA2YyIsInByb3h5SWQiOiIxMzRmNmE2Ny1jOTM1LTQ4OWQtYjU0Yi04NjIyNjJjYWM2MTkifQ=="
cloud_proxy_root_password             = "VMw@re1!"
cloud_proxy_root_password_mindays     = 0
cloud_proxy_root_password_maxdays     = 365
cloud_proxy_root_password_warndays    = 14
cloud_proxy_name                      = "sfo-vmc-cdp01"
cloud_proxy_display_name              = "sfo-vmc-cdp01"
cloud_proxy_network_proxy_hostname_ip = null
cloud_proxy_network_proxy_port        = null
cloud_proxy_network_proxy_username    = null
cloud_proxy_network_proxy_password    = null
cloud_proxy_ip_address                = "172.18.95.80"
cloud_proxy_netmask                   = "255.255.255.0"
cloud_proxy_gateway                   = "172.18.95.1"
cloud_proxy_domain                    = "sfo-vmc-cdp01.sfo.rainpole.io"
cloud_proxy_dns_search                = "sfo.rainpole.io"
cloud_proxy_dns_servers               = "172.18.95.4,172.18.95.5"
cloud_proxy_disk_provisioning         = "thin"