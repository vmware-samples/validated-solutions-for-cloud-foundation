# Copyright 2023 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2

# ===================================================================================================================
# Created by: Bhumitra Nagar
# Authors:    Bhumitra Nagar
# ===================================================================================================================
#
# Description:
# Generates the notifications JSON based on user inputs.

import json
import sys
import os
import argparse

class CreateNotificationsJsonFromTemplate(object):

    def __init__(self, args):
        self.input_file = args.input_file
        self.output_file = args.output_file

    def generate_json_from_template(self):

        # Define the available plugin types.
        plugin_types = {
            "1": "Email",
            "2": "Slack"
        }
        print("#"*50)
        print(f"Input file: {self.input_file}")
        print(f"Output file: {self.output_file}")
        print("#" * 50)
        # Display the available plugin types.

        print("Select the plugin type:")
        for option, plugin_type in plugin_types.items():
            print(f"{option}. {plugin_type}")

        while True:
            # Prompt the user to enter the option number or "Q/q" to exit
            plugin_type_option = input("Select the plugin type number or 'Q' to exit: ").upper()

            # Check if the user wants to exit
            if plugin_type_option == "Q":
                sys.exit(0)

            # Validate the user input
            if plugin_type_option in plugin_types:
                plugin_selection = plugin_types[plugin_type_option]
                break
            else:
                print("Invalid option. Please try again.")

        if plugin_selection == "Email":
            plugin_type = "StandardEmailPlugin"
            plugin_description = "email"
        elif plugin_selection == "Slack":
            plugin_type = "GenericRestPlugin-slack"
            plugin_description = "Slack"

        # Get user inputs
        plugin_name = input("Enter the plugin name configured in VMware Aria Operations "
                            "\n (VMware Aria Operations > Configure > Alerts > Outbound Settings > Instance Name): ")
        if plugin_type == "StandardEmailPlugin":
            property_name = "emailaddr"
            property_value = input(f"Enter the recipient(s) for the {plugin_description} plugin "
                                   "(e.g., hello@rainpole.io or foo@rainpole.io;bar@rainpole.io): ")
        elif plugin_type == "GenericRestPlugin-slack":
            property_name = "url"
            property_value = input(f"Enter the webhook URL for the {plugin_description} plugin "
                                   "(e.g., https://hooks.slack.com/services/...): ")

        # Set values in the JSON file
        with open(self.input_file, 'r') as in_file, open(self.output_file, 'w') as out_file:
            data = json.load(in_file)
            for rule in data['NotificationRules']['notificationRules']:
                for sub_rule in rule['NotificationRule']:
                    sub_rule['PluginID']['@pluginType'] = plugin_type
                    sub_rule['PluginID']['@pluginName'] = plugin_name
                    sub_rule['PluginType'] = plugin_type
                    sub_rule['PluginNotificationProperty']['PropertyName'] = property_name
                    sub_rule['PluginNotificationProperty']['PropertyValue'] = property_value
            json.dump(data, out_file, indent=4)

        print("JSON file generated at location:", os.path.abspath(self.output_file))

if __name__ == "__main__":
    parser = argparse.ArgumentParser(formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument("-i", "--input-file", default='notifications-template.json',
                        help="Specify the input JSON file. Default: notifications-template.json",
                        required=False)
    parser.add_argument('-o', '--output-file', default='notifications.json',
                        help="Specify the output JSON file. Default: notifications.json",
                        required=False)

    args = parser.parse_args()
    c = CreateNotificationsJsonFromTemplate(args)
    c.generate_json_from_template()
