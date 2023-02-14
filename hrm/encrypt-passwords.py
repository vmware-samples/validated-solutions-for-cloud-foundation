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
