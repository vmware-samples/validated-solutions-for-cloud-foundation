# Copyright 2023-2024 Broadcom. All Rights Reserved.
# SPDX-License-Identifier: BSD-2

# ===================================================================================================================
# Created by: Bhumitra Nagar
# Authors:    Bhumitra Nagar
# ===================================================================================================================
#
# Description:
# Encrypts the passwords for SDDC Manager and VMware Aria Operations credentials. 
# Passwords are encrypted and saved in an encrypted_pwds file and a key file in encrypted_files directory.
#
# Example:
# python encrypt-passwords.py

from cryptography.fernet import Fernet
import os
import maskpass
import json

class EncryptPasswords:

    def __init__(self):
        pass

    def read_data(self, data_file):
        with open(data_file) as df:
            data = json.load(df)
        return data

    def generate_encrypted_pwds(self):
        env_info = self.read_data('env.json')
        vrops_user = env_info["vrops"]["user"]
        sddc_manager_user = env_info["sddc_manager"]["user"]
        sddc_manager_local_user = env_info["sddc_manager"]["local_user"]
        vrops_pwd = maskpass.askpass(prompt=f"Enter password for VMware Aria Operations user - {vrops_user}: ", mask="*")
        sddc_manager_user_pwd = maskpass.askpass(prompt=f"Enter password for SDDC Manager user - {sddc_manager_user}: ",
                                                 mask="*")
        sddc_manager_vcf_pwd = maskpass.askpass(prompt=f"Enter password for SDDC Manager local user - "
                                                        f"{sddc_manager_local_user}: ", mask="*")

        # generate key and write to file
        key = Fernet.generate_key()
        with open(os.path.join('encrypted_files', 'key'), "wb") as f:
            f.write(key)

        # encrypt and write to file
        rKey = Fernet(key)
        bvrops_pwd = bytes(vrops_pwd, 'utf-8')
        enc_vrops_pwd = rKey.encrypt(bvrops_pwd)

        bsddc_user = bytes(sddc_manager_user_pwd, 'utf-8')
        enc_sddc_user = rKey.encrypt(bsddc_user)

        bsddc_local_user = bytes(sddc_manager_vcf_pwd, 'utf-8')
        env_sddc_local_user = rKey.encrypt(bsddc_local_user)

        with open(os.path.join('encrypted_files', 'encrypted_pwds'), "wb") as ep:
            ep.write(enc_vrops_pwd + b'\n')
            ep.write(enc_sddc_user + b'\n')
            ep.write(env_sddc_local_user)

        print(f'Encrypted Password files saved to {os.path.abspath("encrypted_files")}')


if __name__ == "__main__":
    ep = EncryptPasswords()
    ep.generate_encrypted_pwds()
