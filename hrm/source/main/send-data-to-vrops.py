# Copyright 2022-2023 VMware, Inc.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# ===================================================================================================================
# Created by:  Bhumitra Nagar - Senior Member of Technical Staff
# Authors: Bhumitra Nagar, Sowjanya V
# Date:   2023-05-04
# Version: 1.1.0.1003
# ===================================================================================================================
#
# Description:
# The send-data-to-vrops.py script receives the operational health data as JSON from SOS utility and supporting
# Powershell modules and then sends it to objects in vRealize Operations as custom metrics for use in dashboards
# to monitor the platform's health.
#
# Change Log:
# ---------------------------------------------------------------------------------------
#    Version - Description
# 1.1.0.1003 - docs: readme update and update version and dist files for release
# 1.1.0.1002 - chore: code cleanup
# 1.1.0.1001 - bug: [HRM] Date on Backups and Snapshot dashboard shown incorrectly #50
# 1.1.0.1001 - artifacts_update: Updated views for backup and snapshots to address issue #50
# 1.1.0.1001 - feat: [HRM] Remove SDDC Manager root password from Python module #38
# 1.1.0.1000 - feat: [HRM] Update project structure to host module on PyPI
# ---------------------------------------------------------------------------------------
# 1.0.0.1002 - bug: [HRM] Exception while sending Backup status data to vROps #48
#
# Example:
# python send-data-to-vrops.py [-options]
#
# [Options]:
# -np : Retrieves the health data from SOS Utility and Powershell cmdlets and saves it JSON files.
# It will not send the data to vRealize Operations


import argparse
import nagini
import requests
import json
import os
import time
import datetime
import re
from requests.packages.urllib3.exceptions import InsecureRequestWarning
from utils.LogUtility import LogUtility
from utils.FolderUtility import FolderUtility
from utils.SosRest import SosRest
from utils.PSUtility import PSUtility
from cryptography.fernet import Fernet


def push_handler(func):
    def inner_function(*args, **kwargs):
        try:
            func(*args, **kwargs)
            args[0].logger.info('############################################################################')
        except Exception as e:
            args[0].logger.error('Exception occurred. Details - ')
            args[0].logger.error(e)
    return inner_function


class PushDataVrops:

    def __init__(self, args):
        os.chdir(os.path.dirname(os.path.abspath(__file__)))
        env_file = args.env_json
        env_info = self.read_data(env_file)

        # set logger
        log_level = env_info["log_level"]
        self.logger = LogUtility.get_logger(log_level)

        # set env
        requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
        self.logger.info('Gathering environment info..')
        self.logger.info(f'script started in path - {os.getcwd()}')
        self.logger.info(f'change current working directory to - {os.path.dirname(__file__)}')
        self.logger.info(os.getcwd())
        self.logger.info(f'Log files located at - {self.logger.test_log_folder}')

        # set script options
        self.push_to_vrops = args.push_data

        # read env.json info
        self.adapter_kind = env_info["adapterKind"]
        self.vm_resource_kind = env_info["vm_resourceKind"]
        self.pod_resource_kind = env_info["pod_resourceKind"]
        self.cluster_resource_kind = env_info["cluster_resourceKind"]
        self.esx_adapter_kind = env_info["esx_adapterKind"]
        self.esx_resource_kind = env_info["esx_resourceKind"]
        self.nsx_adapter_kind = env_info["nsx_adapterKind"]
        self.nsx_resource_kind = env_info["nsx_resourceKind"]
        self.forward_lookup = env_info["constants"]["forward_dns_lookup"]
        self.reverse_lookup = env_info["constants"]["reverse_dns_lookup"]
        self.data_file = env_info["constants"]["data_file"]
        self.component_connectivity_json = env_info["constants"]["component_connectivity_json"]
        self.backup_status_json = env_info["constants"]["backup_status_json"]
        self.storagecapacityhealth_status_json = env_info["constants"]["storagecapacityhealth_status_json"]
        self.nsxtcombinedhealthnonsos_status_json = env_info["constants"]["nsxtcombinedhealthnonsos_status_json"]
        self.snapshot_status_json = env_info["constants"]["snapshot_status_json"]
        self.nsxttier0bgp_status_json = env_info["constants"]["nsxttier0bgp_status_json"]
        self.nsxttransportnode_status_json = env_info["constants"]["nsxttransportnode_status_json"]
        self.nsxttntunnel_status_json = env_info["constants"]["nsxttntunnel_status_json"]

        self.vrops_fqdn = env_info["vrops"]["fqdn"]
        self.vrops_passwd = None
        self.vrops_user = env_info["vrops"]["user"]
        self.sddc_manager_fqdn = env_info["sddc_manager"]["fqdn"]
        self.sddc_manager_pwd = None
        self.sddc_manager_user = env_info["sddc_manager"]["user"]
        self.sddc_manager_local_user = env_info["sddc_manager"]["local_user"]
        self.sddc_manager_local_pwd = None

        # set status codes
        self.codes = {'green': 0, 'yellow': 1, 'red': 2, 'NA': 1, 'skipped': 0}

        # resource inventory object
        self.resource_inventory = {}

        try:
            self.log_retention = int(env_info["log_retention_in_days"])
            self.logger.info(f'Cleaning up older logs from location: '
                             f'{os.path.dirname(self.logger.test_log_folder)}')
            self.logger.info(f'Deleting logs older than {self.log_retention} days')
            FolderUtility.delete_logs_older_than_days(self.log_retention, self.logger)
        except Exception as e:
            self.logger.error('Exception occurred while deleting older logs')
            self.logger.error(e)

        self.decrypt_pwds()

        # get vrops nagini client
        self.vrops = nagini.Nagini(host=self.vrops_fqdn, user_pass=(self.vrops_user, self.vrops_passwd))

        self.logger.info('Fetching data from VMware.CloudFoundation.Reporting cmdlets...')
        self.get_data_from_reporting_module()

        self.logger.info('Fetching data from SOS Utility on SDDC Manager...')
        self.logger.info('This can take 15~90 min (or even more) depending on the size of your environment. '
                         'Please wait....')
        self.data = self.get_sos_data_from_sddc_manager()

        if not self.data:
            self.logger.error("Unable to get data from SOS Utility on SDDC Manager")

    def decrypt_pwds(self):
        # read encrypted pwd and convert into byte
        with open(os.path.join('encrypted_files', 'encrypted_pwds')) as f:
            pwds = []
            for line in f:
                pwds.append(bytes(line, 'utf-8'))

        with open(os.path.join('encrypted_files', 'key')) as f:
            key = ''.join(f.readlines())
            keybyt = bytes(key, 'utf-8')

        fkey = Fernet(keybyt)
        self.vrops_passwd = fkey.decrypt(pwds[0]).decode()
        self.sddc_manager_pwd = fkey.decrypt(pwds[1]).decode()
        self.sddc_manager_local_pwd = fkey.decrypt(pwds[2]).decode()

    def get_resource_mapping_info(self):
        esx_res = self.match_resources(self.esx_resource_kind, self.esx_adapter_kind)
        self.logger.info(f'ESX Resource mapping info - {esx_res}, size {len(esx_res)}')

        nsx_res = self.match_resources(self.nsx_resource_kind, self.nsx_adapter_kind)
        self.logger.info(f'NSX Resource mapping info - {nsx_res},  size {len(nsx_res)}')

        vm_res = self.match_resources(self.vm_resource_kind, self.adapter_kind)
        self.logger.info(f'VM Resource mapping info - {vm_res},  size {len(vm_res)}')

        pod_res = self.match_resources(self.pod_resource_kind, self.adapter_kind)
        self.logger.info(f'Pod Resource mapping info - {pod_res},  size {len(pod_res)}')

        cluster_res = self.match_resources(self.cluster_resource_kind, self.adapter_kind)
        self.logger.info(f'Cluster Resource mapping info - {cluster_res},  size {len(cluster_res)}')

        self.resource_inventory = {**esx_res, **nsx_res, **vm_res, **cluster_res, **pod_res}
        self.logger.info(f'Total number of resources in inventory: {len(self.resource_inventory)}')
        self.logger.info(f'Number of esx resources: {len(esx_res)} ')
        self.logger.info(f'Number of nsx resources: {len(nsx_res)} ')
        self.logger.info(f'Number of vm resources: {len(vm_res)} ')
        self.logger.info(f'Number of cluster resources: {len(cluster_res)} ')
        self.logger.info(f'Number of pod resources: {len(pod_res)} ')

        total_len = len(esx_res) + len(nsx_res) + len(vm_res) + len(cluster_res) + len(pod_res)

        self.logger.info(f'Total resources (adding all categories above): {total_len}')
        if total_len != len(self.resource_inventory):
            self.logger.warn(f'There are duplicate resources in the inventory, please check.')
        return

    def backup_existing_file(self, data_file):
        backup_name = datetime.datetime.now().strftime('health-results_%H_%M_%d_%m_%Y.json')
        # remove existing file health_data_file
        if not os.path.exists('backup'):
            self.logger.info('creating backup directory')
            os.makedirs('backup')
        if os.path.exists(data_file):
            os.replace(data_file, os.path.join('backup', backup_name))

    def get_data_from_reporting_module(self):
        psu = PSUtility(logger=self.logger)
        modules_without_root = ['Publish-BackupStatus',
                                'Publish-NsxtTransportNodeStatus',
                                'Publish-NsxtTransportNodeTunnelStatus',
                                'Publish-NsxtTier0BgpStatus',
                                'Publish-SnapshotStatus',
                                'Publish-ComponentConnectivityHealthNonSOS']

        without_local_user_cmd = f'-server {self.sddc_manager_fqdn} -user {self.sddc_manager_user} ' \
                                 f'-pass {self.sddc_manager_pwd} -allDomains -outputJson {self.logger.test_log_folder}'
        request_token_cmd = f'Request-VCFToken -fqdn {self.sddc_manager_fqdn} -username {self.sddc_manager_user} ' \
                            f'-password {self.sddc_manager_pwd}'
        publish_nsx_cmd = 'Publish-NsxtHealthNonSOS ' + without_local_user_cmd

        combined_cmd = request_token_cmd + ' ; ' + publish_nsx_cmd
        psu.execute_ps_cmd(combined_cmd)

        # module requiring sddc local user
        psu.execute_ps_cmd(f'Publish-StorageCapacityHealth {without_local_user_cmd} '
                           f' -localUser {self.sddc_manager_local_user}'
                           f' -localPass {self.sddc_manager_local_pwd}')

        for module in modules_without_root:
            psu.execute_ps_cmd(f'{module} {without_local_user_cmd}')

        self.logger.info(f'Generated JSON files for Publish-* cmdlets in location {self.logger.test_log_folder}')

    # TODO: change this function
    def get_sos_data_from_sddc_manager(self):
        data = None
        dest = os.path.join(self.logger.test_log_folder, self.data_file)

        sosrest = SosRest(host=self.sddc_manager_fqdn, user=self.sddc_manager_user,
                          password=self.sddc_manager_pwd, logger=self.logger)
        sosrest.get_auth_token()
        request_id = sosrest.start_health_checks_op()
        sosrest.get_health_checks_status(request_id)
        sosrest.get_health_check_bundle(request_id, path=self.logger.test_log_folder)

        if os.path.exists(dest):
            data = self.read_data(os.path.join(dest))
        else:
            self.logger.error(f'Unable to find {self.data_file} in {dest}')
        return data

    def match_resources(self, resource_kind, adapter_kind):
        try:
            resource_data = {}
            page = 0
            page_size = 1000
            data = self.vrops.get_resources(resourceKind=resource_kind, adapterKindKey=adapter_kind,
                                            pageSize=page_size, page=page)

            page_info = data['pageInfo']
            total_count = page_info['totalCount']
            total_pages = int(total_count / page_size)
            for resource in data['resourceList']:
                resource_data[resource['resourceKey']['name']] = resource['identifier']

            while total_pages > 0:
                total_pages = total_pages - 1
                page = page + 1
                data = self.vrops.get_resources(resourceKind=resource_kind, adapterKindKey=adapter_kind,
                                                pageSize=page_size, page=page)
                for resource in data['resourceList']:
                    resource_data[resource['resourceKey']['name']] = resource['identifier']

            self.logger.info(f'Resource inventory data from vROps for ResourceKind: {resource_kind} '
                             f'and AdapterKind: {adapter_kind}')
            self.logger.info(resource_data)

            return resource_data
        except Exception as e:
            self.logger.error(e)
            self.logger.error('Unable to connect to vROps using given credentials')
            raise e

    def read_data(self, data_file):
        with open(data_file) as df:
            data = json.load(df)
        return data

    def get_complete_json_file_name(self, file_name):
        path = None
        for file in os.listdir(self.logger.test_log_folder):
            if file.endswith(file_name):
                path = os.path.join(self.logger.test_log_folder, file)
                break
        if not path:
            self.logger.info(f'Unable to find file ending with {file_name} in {self.logger.test_log_folder}')
        return path

    def push_data(self):
        self.get_resource_mapping_info()
        self.logger.info('############################################################################')

        file_name = self.get_complete_json_file_name(self.backup_status_json)
        self.push_backup_status(file_name)

        file_name = self.get_complete_json_file_name(self.storagecapacityhealth_status_json)
        self.push_storagecapacityhealth_status(file_name)

        file_name = self.get_complete_json_file_name(self.nsxtcombinedhealthnonsos_status_json)
        self.push_nsxtcombinedhealthnonsos_status(file_name)

        file_name = self.get_complete_json_file_name(self.component_connectivity_json)
        self.push_componentconnectivityhealth_status(file_name)

        file_name = self.get_complete_json_file_name(self.snapshot_status_json)
        self.push_snapshot_status(file_name)

        file_name = self.get_complete_json_file_name(self.nsxttier0bgp_status_json)
        self.push_nsxttier0_status(file_name)

        file_name = self.get_complete_json_file_name(self.nsxttransportnode_status_json)
        self.push_nsxt_transportnode_status(file_name)

        file_name = self.get_complete_json_file_name(self.nsxttntunnel_status_json)
        self.push_nsxt_tunnel_status(file_name)

        # pushing data from sos utility health-results.json
        if self.data:
            self.push_data_password()
            self.push_data_certificates()
            self.push_dns_lookup(self.forward_lookup)
            self.push_dns_lookup(self.reverse_lookup)
            self.push_ntp()
            self.push_services()
            self.push_compute()
            self.push_vsan()
            self.push_connectivity()
            self.push_hw_compatibility()
            self.push_general()
        else:
            self.logger.info('Skipping pushing SOS data to vROps. No data received.')

        self.logger.info("############################### Script Complete ############################################")
        self.logger.info(f'Log files located at - {self.logger.test_log_folder}')

    def get_most_nested_dict(self, dictionary, parent_key=None, prev_keys=[]):
        for key, value in dictionary.items():
            if type(value) is dict:
                parent_key = key
                prev_keys.append(key)
                yield from self.get_most_nested_dict(value, parent_key, prev_keys)
            else:
                yield dictionary, parent_key, prev_keys
                break

    def push_data_to_vrops(self, category, resource_id, hostname, metrics_payload_json):
        if category.lstrip().startswith("HRM"):
            suc_log_msg = f'********************** Pushed "{category}" to vROps **********************'
            fail_log_msg = f'********************** Unable to Push "{category}" to vROps**********************'
        else:
            suc_log_msg = f'********************** Pushed "SOS {category}" to vROps **********************'
            fail_log_msg = f'********************** Unable to Push "SOS {category}" to vROps **********************'

        if not resource_id:
            self.logger.error(f'Unable to add data for Hostname: {hostname} | Resource id: {resource_id}')
            self.logger.error(fail_log_msg)
        else:
            if self.push_to_vrops:
                self.vrops.add_stats(metrics_payload_json, id=resource_id)
                self.logger.info(suc_log_msg)
            else:
                self.logger.info(f"********************** Will not push '{category}' data to vROps ******************")

    @push_handler
    def push_general(self):
        category = "General"
        update_count = 0
        for d, parent_key, prev_keys in self.get_most_nested_dict(self.data[category]):
            if parent_key == "":
                continue
            if parent_key == "Vcenter Ring Topology Status":
                hostname = self.sddc_manager_fqdn
                component = 'SDDCMANAGER'
            else:
                if ':' in d['area']:
                    component, hostname = d['area'].split(':')
                else:
                    hostname = d['area']
                    component = 'NA'
                hostname = hostname.lstrip('*').lstrip().rstrip()
                component = component.lstrip('*').rstrip().lstrip()
            resource_name = hostname.split(".")[0]
            self.logger.info(f'Hostname: {hostname}, Component: {component}')

            resource_id = self.get_resource_id(hostname, resource_name)

            metrics_payload = {"stat-content": []}
            timestamp_raw = d['timestamp']
            timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())

            if 'NSX Edge Cluster Health Status' in d['title']:
                metric_key = 'NSX Edge Cluster Health Status'
            elif 'NSX Edge Health Status' in d['title']:
                metric_key = 'NSX Edge Health Status'
            elif 'No NSX Edge Cluster available' in d['title']:
                metric_key = 'NSX Edge Cluster Health Status'
            elif parent_key not in d['area']:
                metric_key = d['title'].lstrip('*').rstrip().lstrip().split("\n")[0]
            else:
                prev_keys.pop()
                metric_key = prev_keys[-1]

            for k, v in d.items():
                details = {
                    "statKey": f"SOS General|{metric_key}|{k}",
                    "timestamps": [int(timestamp * 1000)],
                    "data" if isinstance(v, int) else "values": [v]
                }

                metrics_payload["stat-content"].append(details)
                if k == 'alert':
                    details = {
                        "statKey": f"SOS General|{metric_key}|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)
            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count}')

    @push_handler
    def push_hw_compatibility(self):
        category = "Hardware Compatibility"
        update_count = 0
        for d, parent_key, prev_keys in self.get_most_nested_dict(self.data[category]):
            if parent_key == "":
                continue
            component, hostname = d['area'].split(':')
            hostname = hostname.lstrip().rstrip()
            component = component.rstrip().lstrip()
            self.logger.info(f'Hostname: {hostname}, Component: {component}')

            resource_id = self.get_resource_id(hostname, None)

            metrics_payload = {"stat-content": []}
            timestamp_raw = d['timestamp']
            timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())

            for k, v in d.items():
                if k.lower() == 'title':
                    flat_list = []
                    for sublist in v:
                        if type(sublist) == list:
                            for item in sublist:
                                flat_list.append(item)
                        else:
                            flat_list.append(sublist)
                    v = ','.join(flat_list)
                details = {
                    "statKey": f"SOS Hardware Compatibility|{parent_key}|{k}",
                    "timestamps": [int(timestamp * 1000)],
                    "data" if isinstance(v, int) else "values": [v]
                }
                metrics_payload["stat-content"].append(details)
                if k == 'alert':
                    details = {
                        "statKey": f"SOS Hardware Compatibility|{parent_key}|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)
            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count}')

    @push_handler
    def push_connectivity(self):
        category = "Connectivity"
        update_count = 0
        for d, parent_key, prev_keys in self.get_most_nested_dict(self.data[category]):
            if parent_key == "NSX Ping Status":
                continue
            if parent_key == "Vcenter Ring Topology Status":
                hostname = self.sddc_manager_fqdn
                component = 'SDDCMANAGER'
            else:
                component, hostname = d['area'].split(':')
                hostname = hostname.lstrip().rstrip()
                component = component.rstrip().lstrip()
            resource_name = hostname.split(".")[0]
            self.logger.info(f'Hostname: {hostname}, Component: {component}')

            resource_id = self.get_resource_id(hostname, resource_name)

            metrics_payload = {"stat-content": []}
            timestamp_raw = d['timestamp']
            timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())

            for k, v in d.items():
                if 'SSH' in d['title']:
                    details = {
                        "statKey": f"SOS SSH Connectivity Health|{k}",
                        "timestamps": [int(timestamp * 1000)],
                        "data" if isinstance(v, int) else "values": [v]
                    }
                    metrics_payload["stat-content"].append(details)
                    if k == 'alert':
                        details = {
                            "statKey": f"SOS SSH Connectivity Health|alert_code",
                            "timestamps": [int(timestamp * 1000)],
                            "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['skipped']]
                        }
                        metrics_payload["stat-content"].append(details)
                else:
                    details = {
                        "statKey": f"SOS {d['title']}|{k}",
                        "timestamps": [int(timestamp * 1000)],
                        "data" if isinstance(v, int) else "values": [v]
                    }
                    metrics_payload["stat-content"].append(details)
                    if k == 'alert':
                        details = {
                            "statKey": f"SOS {d['title']}|alert_code",
                            "timestamps": [int(timestamp * 1000)],
                            "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                        }
                        metrics_payload["stat-content"].append(details)

                if parent_key != hostname:
                    details = {
                        "statKey": f"SOS {d['title']}|IP",
                        "timestamps": [int(timestamp * 1000)],
                        "data" if isinstance(v, int) else "values": [parent_key]
                    }
                    metrics_payload["stat-content"].append(details)
                    if k == 'alert':
                        details = {
                            "statKey": f"SOS {d['title']}|alert_code",
                            "timestamps": [int(timestamp * 1000)],
                            "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                        }
                        metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)
            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count}')

    @push_handler
    def push_vsan(self):
        category = 'vSAN'
        update_count = 0
        for key, value in self.data[category].items():
            alert_code_val = 0
            if value.get('area'):
                hostname = key
                resource_id = self.get_resource_id(hostname, None)

                metrics_payload = {"stat-content": []}
                timestamp_raw = value['timestamp']
                timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())

                for k, v in value.items():
                    details = {
                        "statKey": f"SOS vSAN Summary|{k}",
                        "timestamps": [int(timestamp * 1000)],
                        "data" if isinstance(v, int) else "values": [v]
                    }
                    metrics_payload["stat-content"].append(details)

                    if k == 'alert':
                        if v.lower() == "":
                            if value['status'].lower() == "passed":
                                alert_code_val = 0
                            else:
                                alert_code_val = 1
                        details = {
                            "statKey": f"SOS vSAN Summary|alert_code",
                            "timestamps": [int(timestamp * 1000)],
                            "data": [self.codes[v.lower()]] if v.lower() in self.codes else [alert_code_val]
                        }
                        metrics_payload["stat-content"].append(details)

                metrics_payload_json = json.dumps(metrics_payload)

                self.logger.info(resource_id)
                self.logger.info(metrics_payload_json)
                self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
                update_count = update_count + 1
            else:
                for host, val in value.items():
                    hostname = host.split(":")[1].split(".")[0].lstrip().rstrip()
                    cluster_name = host.split(":")[2].lstrip().rstrip()
                    resource_id = self.get_resource_id(cluster_name, None)
                    metrics_payload = {"stat-content": []}
                    timestamp_raw = val['timestamp']
                    timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())

                    for k, v in val.items():
                        details = {
                            "statKey": f"SOS vSAN Summary:{key}|{k}",
                            "timestamps": [int(timestamp * 1000)],
                            "data" if isinstance(v, int) else "values": [v]
                        }
                        metrics_payload["stat-content"].append(details)
                        if k == 'alert':
                            if v.lower() == "":
                                if val['status'].lower() == "passed":
                                    alert_code_val = 0
                                else:
                                    alert_code_val = 1
                            details = {
                                "statKey": f"SOS vSAN Summary:{key}|alert_code",
                                "timestamps": [int(timestamp * 1000)],
                                "data": [self.codes[v.lower()]] if v.lower() in self.codes else [alert_code_val]
                            }
                            metrics_payload["stat-content"].append(details)

                    metrics_payload_json = json.dumps(metrics_payload)

                    self.logger.info(resource_id)
                    self.logger.info(metrics_payload_json)
                    self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
                    update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count}')

    @push_handler
    def push_compute(self):
        category = "Compute"
        update_count = 0
        for key, value in self.data[category].items():
            for host, val in value.items():
                component, hostname = val['area'].split(':')
                hostname = hostname.lstrip().rstrip()
                component = component.rstrip().lstrip()
                resource_name = hostname.split(".")[0]
                self.logger.info(f'Hostname: {hostname}, Component: {component}')

                metrics_payload = {"stat-content": []}

                timestamp_raw = val['timestamp']
                timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())

                resource_id = self.get_resource_id(hostname, resource_name)

                for k, v in val.items():
                    details = {
                        "statKey": f"SOS Compute Summary:{key}|{k}",
                        "timestamps": [int(timestamp * 1000)],
                        "data" if isinstance(v, int) else "values": [v]
                    }
                    metrics_payload["stat-content"].append(details)
                    if k == 'alert':
                        details = {
                            "statKey": f"SOS Compute Summary:{key}|alert_code",
                            "timestamps": [int(timestamp * 1000)],
                            "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                        }
                        metrics_payload["stat-content"].append(details)

                metrics_payload_json = json.dumps(metrics_payload)

                self.logger.info(resource_id)
                self.logger.info(metrics_payload_json)
                self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
                update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count}')

    @push_handler
    def push_services(self):
        category = "Services"
        update_count = 0
        for element in self.data[category]:
            for key, value in element.items():
                component, hostname = value['area'].split(':')
                hostname = hostname.lstrip().rstrip()
                component = component.rstrip().lstrip()
                resource_name = hostname.split(".")[0]
                self.logger.info(f'Hostname: {hostname}, Component: {component}')

                metrics_payload = {"stat-content": []}

                timestamp_raw = value['timestamp']
                timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())

                resource_id = self.get_resource_id(hostname, resource_name)

                for k, val in value.items():
                    details = {
                        "statKey": f"SOS Services Summary:{value['title']}|{k}",
                        "timestamps": [int(timestamp * 1000)],
                        "data" if isinstance(val, int) else "values": [val]
                    }
                    metrics_payload["stat-content"].append(details)
                    if k == 'alert':
                        details = {
                            "statKey": f"SOS Services Summary:{value['title']}|alert_code",
                            "timestamps": [int(timestamp * 1000)],
                            "data": [self.codes[val.lower()]]
                        }
                        metrics_payload["stat-content"].append(details)

                metrics_payload_json = json.dumps(metrics_payload)

                self.logger.info(resource_id)
                self.logger.info(metrics_payload_json)
                self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
                update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count}')

    @push_handler
    def push_ntp_iterator(self, category, data):
        category_orig = category
        update_count = 0
        for key, value in data.items():
            if key != 'ESXi Time' and key != 'ESXi HW Time':
                hostname = key.rstrip()
                category = category_orig
            else:
                if value != {}:
                    try:
                        hostname = value['area'].split(':')[1].lstrip().rstrip()
                        category = key
                    except Exception:
                        self.push_ntp_iterator(key, value)
                        category_orig = category
                        continue
                else:
                    continue
            resource_name = hostname.split(".")[0]
            self.logger.info(f'Hostname: {hostname}')
            metrics_payload = {"stat-content": []}

            timestamp_raw = value['timestamp']
            timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())
            resource_id = self.get_resource_id(hostname, resource_name)

            for k, val in value.items():
                details = {
                    "statKey": f"SOS {category} Status Summary|{k}",
                    "timestamps": [int(timestamp * 1000)],
                    "data" if isinstance(val, int) else "values": [val]
                }
                metrics_payload["stat-content"].append(details)
                if k == 'alert':
                    details = {
                        "statKey": f"SOS {category} Status Summary|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[val.lower()]]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)

            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count}')

    @push_handler
    def push_ntp(self):
        ntp = "NTP"
        self.push_ntp_iterator(ntp, self.data[ntp])

    @push_handler
    def push_dns_lookup(self, dns_type):
        category = "DNS lookup Status"
        update_count = 0
        for key, value in self.data[category][dns_type].items():
            hostname = key.rstrip()
            resource_name = hostname.split(".")[0]
            self.logger.info(f'Hostname = {hostname}')
            metrics_payload = {"stat-content": []}

            timestamp_raw = value['timestamp']
            timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())
            resource_id = self.get_resource_id(hostname, resource_name)

            for k, val in value.items():
                details = {
                    "statKey": f"SOS DNS {dns_type} Summary|{k}",
                    "timestamps": [int(timestamp * 1000)],
                    "data" if isinstance(val, int) else "values": [val]
                }

                metrics_payload["stat-content"].append(details)
                if k == 'alert':
                    details = {
                        "statKey": f"SOS DNS {dns_type} Summary|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[val.lower()]]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)

            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count}')

    def get_resource_id(self, hostname, resource_name):
        resource_id = self.resource_inventory.get(hostname)
        if not resource_id and resource_name:
            resource_id = self.resource_inventory.get(resource_name)
        if not resource_id and resource_name:
            for name, res_id in self.resource_inventory.items():
                if resource_name in name or hostname in name:
                    resource_id = res_id
                    break
        return resource_id

    def push_flat_struct(self, data_type, data_arr, key_var):
        update_count = 0
        category = f"HRM {data_type} Status"
        self.logger.info(f'Pushing {data_type} status data to vROps')
        for arr_val in data_arr:
            data = arr_val
            user = None
            component = None
            if arr_val.get("User"):
                user = arr_val["User"]
            if arr_val.get("Component"):
                component = arr_val["Component"]
            if key_var:
                hostname = data[key_var]
            else:
                hostname = data["Resource"]
            resource_name = hostname.split(".")[0]
            self.logger.info(f'Hostname: {hostname}, Component: {component}')
            metrics_payload = {"stat-content": []}

            timestamp = time.mktime(datetime.datetime.now().timetuple())
            resource_id = self.get_resource_id(hostname, resource_name)

            for k, v in arr_val.items():
                if user:
                    statkey = f"HRM {data_type} Status:{user}"
                else:
                    statkey = f"HRM {data_type} Status"

                details = {
                    "statKey": f"{statkey}|{k.lower()}",
                    "timestamps": [int(timestamp * 1000)],
                    "values": [v]
                }
                metrics_payload["stat-content"].append(details)
                if k.lower() == 'alert':
                    details = {
                        "statKey": f"{statkey}|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)

            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1
        return update_count

    @push_handler
    def push_data_password(self):
        category = "Password Expiry Status"
        self.logger.info('Pushing SOS password data to vROps')
        update_count = 0
        for key, value in self.data[category].items():
            hostname, user = key.split(':')
            hostname = hostname.rstrip()
            user = user.rstrip().lstrip()
            resource_name = hostname.split(".")[0]
            component = value['area'].split(":")[0].rstrip()
            self.logger.info(f"hostname = {hostname}, component = {component}")
            metrics_payload = {"stat-content": []}

            timestamp_raw = value['timestamp']
            timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())
            resource_id = self.get_resource_id(hostname, resource_name)

            for k, v in value.items():
                if k == 'title':
                    for k1, val in value['title'].items():
                        if key != 'host':
                            if not isinstance(val, int) and val.lower() == 'never':
                                val = 999999999
                            details = {
                                "statKey": f"SOS Password Summary:{user}|{k1}",
                                "timestamps": [int(timestamp * 1000)],
                                "data" if isinstance(val, int) else "values": [val]
                            }
                            metrics_payload["stat-content"].append(details)
                else:
                    details = {
                        "statKey": f"SOS Password Summary:{user}|{k}",
                        "timestamps": [int(timestamp * 1000)],
                        "values": [v]
                    }
                    metrics_payload["stat-content"].append(details)
                    if k == 'alert':
                        details = {
                            "statKey": f"SOS Password Summary:{user}|alert_code",
                            "timestamps": [int(timestamp * 1000)],
                            "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                        }
                        metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)

            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count} ')

    @push_handler
    def push_backup_status(self, file_name):
        data_arr = self.read_data(file_name)
        update_count = 0
        category = "HRM Backup Status"
        data_type = "Backup"
        self.logger.info(f'Pushing {data_type} status data to vROps')

        for data in data_arr:
            component = data["Component"]
            index_val = data["Resource"]
            hostname = data["Element"]
            if component == "NSX Manager":
                statkey = f"HRM {data_type} Status:{index_val}"
            else:
                statkey = f"HRM {data_type} Status"
            resource_name = hostname.split(".")[0]
            self.logger.info(f'Hostname: {hostname}, Component: {component}')
            metrics_payload = {"stat-content": []}
            timestamp = time.mktime(datetime.datetime.now().timetuple())
            resource_id = self.get_resource_id(hostname, resource_name)

            for k, v in data.items():
                if k.lower() == 'date':
                    k = "date_taken"
                    if v:
                        match = re.search(r"\d{10}", v)
                        if match:
                            timestamp_raw = int(match.group())
                            parsed_date = datetime.datetime.fromtimestamp(timestamp_raw)
                            datetime_str = parsed_date.strftime("%b %d %H:%M:%S %Y GMT")
                            v = datetime_str
                        else:
                            match = re.search("\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}", v)
                            if match:
                                date_format = "%Y-%m-%dT%H:%M:%S"
                                parsed_date = datetime.datetime.strptime(match.group(), date_format)
                                datetime_str = parsed_date.strftime("%b %d %H:%M:%S %Y GMT")
                                v = datetime_str
                    else:
                        v = ""
                details = {
                    "statKey": f"{statkey}|{k.lower()}",
                    "timestamps": [int(timestamp * 1000)],
                    "values": [v]
                }
                metrics_payload["stat-content"].append(details)
                if k.lower() == 'alert':
                    details = {
                        "statKey": f"{statkey}|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)

            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count} ')

    @push_handler
    def push_snapshot_status(self, file_name):
        data_arr = self.read_data(file_name)
        category = "HRM Snapshot Status"
        data_type = "Snapshot"
        self.logger.info(f'Pushing {data_type} status data to vROps')
        update_count = 0
        for data in data_arr:
            component = data["Component"]
            hostname = data["Element"]
            resource_name = hostname.split(".")[0]
            self.logger.info(f'Hostname: {hostname}, Component: {component}')
            metrics_payload = {"stat-content": []}

            timestamp = time.mktime(datetime.datetime.now().timetuple())
            resource_id = self.get_resource_id(hostname, resource_name)

            for k, v in data.items():
                if k.lower() == 'latest':
                    k = "date_taken"
                    if v:
                        match = re.search(r"\d{10}", v)
                        if match:
                            timestamp_raw = int(match.group())
                            parsed_date = datetime.datetime.fromtimestamp(timestamp_raw)
                            datetime_str = parsed_date.strftime("%b %d %H:%M:%S %Y GMT")
                            v = datetime_str
                        else:
                            match = re.search("\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}", v)
                            if match:
                                date_format = "%Y-%m-%dT%H:%M:%S"
                                parsed_date = datetime.datetime.strptime(match.group(), date_format)
                                datetime_str = parsed_date.strftime("%b %d %H:%M:%S %Y GMT")
                                v = datetime_str
                    else:
                        v = ""
                details = {
                    "statKey": f"HRM {data_type} Status|{k.lower()}",
                    "timestamps": [int(timestamp * 1000)],
                    "values": [v]
                }
                metrics_payload["stat-content"].append(details)
                if k.lower() == 'alert':
                    details = {
                        "statKey": f"HRM {data_type} Status|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)

            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count} ')

    @push_handler
    def push_localuserexpiry_status(self, file_name):
        data_type = "Localuserexpiry"
        datastruct = self.get_complete_json_file_name(file_name)
        update_count = self.push_flat_struct(data_type, datastruct, None)
        self.logger.info(f'Total object update requests = {update_count} ')

    @push_handler
    def push_componentconnectivityhealth_status(self, file_name):
        data_type = "ComponentConnectivityHealth"
        datastruct = self.read_data(file_name)
        update_count = self.push_flat_struct(data_type, datastruct, None)
        self.logger.info(f'Total object update requests = {update_count} ')

    @push_handler
    def push_storagecapacityhealth_status(self, file_name):
        update_count = 0
        datastruct = self.read_data(file_name)

        for key_val in datastruct.keys():
            data_arr = datastruct[key_val]
            if key_val == "esxi":
                key_var = "ESXi FQDN"
                category = "HRM StorageCapacityHealth Status"
                data_type = "StorageCapacityHealth"
                for arr_val in data_arr:
                    data = arr_val
                    hostname = data[key_var]
                    resource_name = hostname.split(".")[0]
                    self.logger.info(f"hostname = {hostname}")
                    metrics_payload = {"stat-content": []}

                    # timestamp_raw = value['timestamp']
                    timestamp = time.mktime(datetime.datetime.now().timetuple())
                    resource_id = self.get_resource_id(hostname, resource_name)

                    for k, v in arr_val.items():
                        index_val = arr_val["Volume Name"]
                        statkey = f"HRM {data_type} Status:{index_val}"
                        details = {
                            "statKey": f"{statkey}|{k.lower()}",
                            "timestamps": [int(timestamp * 1000)],
                            "values": [v]
                        }
                        metrics_payload["stat-content"].append(details)
                        if k.lower() == 'alert':
                            details = {
                                "statKey": f"{statkey}|alert_code",
                                "timestamps": [int(timestamp * 1000)],
                                "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                            }
                            metrics_payload["stat-content"].append(details)

                    metrics_payload_json = json.dumps(metrics_payload)

                    self.logger.info(resource_id)
                    self.logger.info(metrics_payload_json)
                    self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
                    update_count = update_count + 1

            elif key_val == "datastore":
                key_var = "vCenter Server"
                category = "HRM StorageCapacityDatastoreHealth Status"
                data_type = "StorageCapacityDatastoreHealth"
                for arr_val in data_arr:
                    data = arr_val
                    hostname = data[key_var]
                    resource_name = hostname.split(".")[0]
                    self.logger.info(f"hostname = {hostname}")
                    metrics_payload = {"stat-content": []}

                    timestamp = time.mktime(datetime.datetime.now().timetuple())
                    resource_id = self.get_resource_id(hostname, resource_name)

                    for k, v in arr_val.items():
                        index_val = arr_val["Datastore Name"]
                        statkey = f"HRM {data_type} Status:{index_val}"
                        details = {
                            "statKey": f"{statkey}|{k.lower()}",
                            "timestamps": [int(timestamp * 1000)],
                            "values": [v]
                        }
                        metrics_payload["stat-content"].append(details)
                        if k.lower() == 'alert':
                            details = {
                                "statKey": f"{statkey}|alert_code",
                                "timestamps": [int(timestamp * 1000)],
                                "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                            }
                            metrics_payload["stat-content"].append(details)

                    metrics_payload_json = json.dumps(metrics_payload)

                    self.logger.info(resource_id)
                    self.logger.info(metrics_payload_json)
                    self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
                    update_count = update_count + 1
            else:
                key_var = "FQDN"
                category = "HRM StorageCapacityFilesystemHealth Status"
                data_type = "StorageCapacityFilesystemHealth"
                for arr_val in data_arr:
                    data = arr_val
                    index_val = data["Filesystem"]
                    hostname = data[key_var]
                    resource_name = hostname.split(".")[0]
                    self.logger.info(f"hostname = {hostname}")
                    metrics_payload = {"stat-content": []}

                    timestamp = time.mktime(datetime.datetime.now().timetuple())
                    resource_id = self.get_resource_id(hostname, resource_name)
                    for k, v in arr_val.items():
                        statkey = f"HRM {data_type} Status:{index_val}"
                        details = {
                            "statKey": f"{statkey}|{k.lower()}",
                            "timestamps": [int(timestamp * 1000)],
                            "values": [v]
                        }
                        metrics_payload["stat-content"].append(details)
                        if k.lower() == 'alert':
                            details = {
                                "statKey": f"{statkey}|alert_code",
                                "timestamps": [int(timestamp * 1000)],
                                "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                            }
                            metrics_payload["stat-content"].append(details)

                    metrics_payload_json = json.dumps(metrics_payload)

                    self.logger.info(resource_id)
                    self.logger.info(metrics_payload_json)
                    self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)

                    update_count = update_count + 1
        self.logger.info(f'Total object update requests = {update_count} ')

    @push_handler
    def push_nsxttier0_status(self, file_name):
        data_arr = self.read_data(file_name)
        category = "HRM NSXT TIER0 BGP Backup Status"
        self.logger.info('Pushing nsxt tier0 bgp status data to vROps')
        update_count = 0
        instance_hash = {}

        for arr_val in data_arr:
            instance_name = arr_val["NSX Manager"]
            instance_hash[instance_name] = 0

        for arr_val in data_arr:
            data = arr_val
            hostname = data["NSX Manager"]
            resource_name = hostname.split(".")[0]
            self.logger.info(f"hostname = {hostname}")
            metrics_payload = {"stat-content": []}
            timestamp = time.mktime(datetime.datetime.now().timetuple())
            resource_id = self.get_resource_id(hostname, resource_name)

            for k, v in arr_val.items():
                details = {
                    "statKey": f"{category}:{instance_hash[hostname]}|{k.lower()}",
                    "timestamps": [int(timestamp * 1000)],
                    "values": [v]
                }
                metrics_payload["stat-content"].append(details)
                if k.lower() == 'alert':
                    details = {
                        "statKey": f"{category}:{instance_hash[hostname]}|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)

            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1
            instance_hash[hostname] += 1

        self.logger.info(f'Total object update requests = {update_count} ')

    @push_handler
    def push_nsxt_transportnode_status(self, file_name):
        data_arr = self.read_data(file_name)
        category = "HRM NSXT Transport Node Status"
        self.logger.info('Pushing nsxt transport node status data to vROps')
        update_count = 0
        instance_hash = {}

        for arr_val in data_arr:
            instance_name = arr_val["Resource"]
            instance_hash[instance_name] = 0

        for arr_val in data_arr:
            data = arr_val
            hostname = data["Resource"]
            resource_name = hostname.split(".")[0]
            self.logger.info(f"hostname = {hostname}")
            metrics_payload = {"stat-content": []}

            # timestamp_raw = value['timestamp']
            timestamp = time.mktime(datetime.datetime.now().timetuple())
            resource_id = self.get_resource_id(hostname, resource_name)

            for k, v in arr_val.items():
                details = {
                    "statKey": f"HRM NSXT Transport Node Status:{instance_hash[hostname]}|{k.lower()}",
                    "timestamps": [int(timestamp * 1000)],
                    "values": [v]
                }
                metrics_payload["stat-content"].append(details)
                if k.lower() == 'alert':
                    details = {
                        "statKey": f"HRM NSXT Transport Node Status:{instance_hash[hostname]}|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)

            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1
            instance_hash[hostname] += 1

        self.logger.info(f'Total object update requests = {update_count} ')

    @push_handler
    def push_nsxt_tunnel_status(self, file_name):
        data_arr = self.read_data(file_name)
        category = "HRM NSXT Tunnel Status"
        self.logger.info('Pushing nsxt tunnel status data to vROps')
        update_count = 0
        instance_hash = {}

        for arr_val in data_arr:
            instance_name = arr_val["Resource"]
            instance_hash[instance_name] = 0

        for arr_val in data_arr:
            data = arr_val
            hostname = data["Resource"]
            resource_name = hostname.split(".")[0]
            self.logger.info(f"hostname = {hostname}")
            metrics_payload = {"stat-content": []}

            # timestamp_raw = value['timestamp']
            timestamp = time.mktime(datetime.datetime.now().timetuple())
            resource_id = self.get_resource_id(hostname, resource_name)

            for k, v in arr_val.items():
                details = {
                    "statKey": f"HRM NSXT Tunnel Status:{instance_hash[hostname]}|{k.lower()}",
                    "timestamps": [int(timestamp * 1000)],
                    "values": [v]
                }
                metrics_payload["stat-content"].append(details)
                if k.lower() == 'alert':
                    details = {
                        "statKey": f"HRM NSXT Tunnel Status:{instance_hash[hostname]}|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)

            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1
            instance_hash[hostname] += 1

        self.logger.info(f'Total object update requests = {update_count} ')

    @push_handler
    def push_nsxtcombinedhealthnonsos_status(self, file_name):
        data_arr = self.read_data(file_name)
        category = "HRM NSXTCombinedHealth Status"
        self.logger.info('Pushing NSXT Combined Health Status data to vROps')
        update_count = 0
        instance_hash = {}

        for arr_val in data_arr:
            instance_name = arr_val["Resource"]
            instance_hash[instance_name] = 0

        for arr_val in data_arr:
            data = arr_val
            component = data["Component"]
            hostname = data["Resource"]
            resource_name = hostname.split(".")[0]
            self.logger.info(f"hostname = {hostname} and component = {component}")
            metrics_payload = {"stat-content": []}

            timestamp = time.mktime(datetime.datetime.now().timetuple())
            resource_id = self.get_resource_id(hostname, resource_name)

            for k, v in arr_val.items():
                details = {
                    "statKey": f"HRM NSXTCombinedHealth Status:{instance_hash[hostname]}|{k.lower()}",
                    "timestamps": [int(timestamp * 1000)],
                    "values": [v]
                }
                metrics_payload["stat-content"].append(details)
                if k.lower() == 'alert':
                    details = {
                        "statKey": f"HRM NSXTCombinedHealth Status:{instance_hash[hostname]}|alert_code",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [self.codes[v.lower()]] if v.lower() in self.codes else [self.codes['NA']]
                    }
                    metrics_payload["stat-content"].append(details)

            metrics_payload_json = json.dumps(metrics_payload)

            self.logger.info(resource_id)
            self.logger.info(metrics_payload_json)
            self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
            update_count = update_count + 1
            instance_hash[hostname] += 1

        self.logger.info(f'Total object update requests = {update_count} ')

    @push_handler
    def push_data_certificates(self):
        category = "Certificates"
        self.logger.info('Pushing SOS Certificate Health data to vROps')
        update_count = 0
        for key, value in self.data[category]['Certificate Status'].items():
            for hostname, cert_data in value.items():
                resource_name = hostname.split(".")[0]
                self.logger.info(f"hostname = {hostname}")

                resource_id = self.get_resource_id(hostname, resource_name)

                metrics_payload = {"stat-content": []}

                timestamp_raw = cert_data['timestamp']
                timestamp = time.mktime(datetime.datetime.strptime(timestamp_raw, "%c").timetuple())
                expires_in = 0
                if cert_data['title'] and "-" not in cert_data['title']:
                    details = {
                        "statKey": f"SOS Certificate Health Summary|fqdn",
                        "timestamps": [int(timestamp * 1000)],
                        "values": [cert_data['title'][0]]
                    }
                    metrics_payload["stat-content"].append(details)
                    details = {
                        "statKey": f"SOS Certificate Health Summary|issue_date",
                        "timestamps": [int(timestamp * 1000)],
                        "values": [cert_data['title'][1]]
                    }
                    metrics_payload["stat-content"].append(details)

                    details = {
                        "statKey": f"SOS Certificate Health Summary|expiry_date",
                        "timestamps": [int(timestamp * 1000)],
                        "values": [cert_data['title'][2]]
                    }
                    metrics_payload["stat-content"].append(details)
                    current = datetime.datetime.now()
                    expiry = datetime.datetime.strptime(cert_data['title'][2], "%b %d %H:%M:%S %Y %Z")
                    expires_in = (expiry - current).days

                    details = {
                        "statKey": f"SOS Certificate Health Summary|expires_in",
                        "timestamps": [int(timestamp * 1000)],
                        "data": [int(expires_in)]
                    }
                    metrics_payload["stat-content"].append(details)

                details = {
                    "statKey": f"SOS Certificate Health Summary|state",
                    "timestamps": [int(timestamp * 1000)],
                    "values": [cert_data['state']]
                }
                metrics_payload["stat-content"].append(details)
                details = {
                    "statKey": f"SOS Certificate Health Summary|message",
                    "timestamps": [int(timestamp * 1000)],
                    "values": [cert_data['message']]
                }
                metrics_payload["stat-content"].append(details)

                alert = "GREEN"
                if int(expires_in) <= 15:
                    alert = "RED"
                elif 15 < int(expires_in) <= 30:
                    alert = "YELLOW"

                details = {
                    "statKey": f"SOS Certificate Health Summary|alert",
                    "timestamps": [int(timestamp * 1000)],
                    "values": [alert]
                }
                metrics_payload["stat-content"].append(details)
                details = {
                    "statKey": f"SOS Certificate Health Summary|alert_code",
                    "timestamps": [int(timestamp * 1000)],
                    "data": [self.codes[alert.lower()]]
                }
                metrics_payload["stat-content"].append(details)

                metrics_payload_json = json.dumps(metrics_payload)

                self.logger.info(resource_id)
                self.logger.info(metrics_payload_json)
                self.push_data_to_vrops(category, resource_id, hostname, metrics_payload_json)
                update_count = update_count + 1

        self.logger.info(f'Total object update requests = {update_count}')


if __name__ == "__main__":
    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument("-e", "--env-json", default='env.json',
                        help="path of env.json file. Default is in same directory as this file")
    parser.add_argument('-p', '--push-data', dest='push_data', action='store_true',
                        help="This is default option to send the data to vROps")
    parser.add_argument('-np', '--no-push-data', dest='push_data', action='store_false',
                        help="Use this option if you do not want to send the data to vROps")
    parser.set_defaults(push_data=True)

    args = parser.parse_args()
    pd = PushDataVrops(args)
    pd.push_data()
