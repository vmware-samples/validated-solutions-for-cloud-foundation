# Copyright 2022-2023 VMware, Inc.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# ===================================================================================================================
# Created by:  Bhumitra Nagar - Senior Member of Technical Staff
# Authors: Bhumitra Nagar
# Date:   2023-02-01
# Version: 1.0.0.1001
# ===================================================================================================================
#
# Description:
# Script to encrypt passwords for SDDC Manager and vRealize Operations credentials. Passwords are encrypted and saved
# in an encrypted_pwds file and a key file in encrypted_files directory.
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
        sddc_manager_root = 'root'
        vrops_pwd = maskpass.askpass(prompt=f"Enter pasword for vRealize Operations user - {vrops_user}: ", mask="*")
        sddc_manager_user_pwd = maskpass.askpass(prompt=f"Enter pasword for SDDC Manager user - {sddc_manager_user}: ",
                                                 mask="*")
        sddc_manager_root_pwd = maskpass.askpass(prompt=f"Enter pasword for SDDC Manager user - "
                                                        f"{sddc_manager_root}: ", mask="*")

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

        bsddc_root = bytes(sddc_manager_root_pwd, 'utf-8')
        env_sddc_root = rKey.encrypt(bsddc_root)

        with open(os.path.join('encrypted_files', 'encrypted_pwds'), "wb") as ep:
            ep.write(enc_vrops_pwd + b'\n')
            ep.write(enc_sddc_user + b'\n')
            ep.write(env_sddc_root)

        print(f'Encrypted Password files saved to {os.path.abspath("encrypted_files")}')


if __name__ == "__main__":
    ep = EncryptPasswords()
    ep.generate_encrypted_pwds()
