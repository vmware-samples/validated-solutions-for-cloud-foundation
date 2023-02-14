# Copyright 2019 VMware, Inc.  All rights reserved. -- VMware Confidential
# Description: SSH Utility
# Disabled: True

from paramiko import SSHClient, AutoAddPolicy


class SshUtility:
    def __init__(self, host, user, password, port=22):
        self.client = SSHClient()
        self.hostname = host
        self.user = user
        self.password = password
        self.port = port

    def connect(self):
        self.client.set_missing_host_key_policy(AutoAddPolicy())
        self.client.connect(self.hostname, self.port, username=self.user, password=self.password, look_for_keys=False)

    def execute(self, cmd):
        try:
            stdin, stdout, stderr = self.client.exec_command(cmd)
            return stdout.readlines()
        except Exception as e:
            print("There was an exception found while executing the command[{}]:\n{}".format(cmd, str(e)))
            raise Exception(e)

    def execute_su(self, cmd, su_pwd):
        try:
            stdin, stdout, stderr = self.client.exec_command(f'sudo -S {cmd}')
            stdin.write(f'{su_pwd}\n')
            stdin.flush()
            return stdout.readlines()
        except Exception as e:
            print("There was an exception found while executing the command[{}]:\n{}".format(cmd, str(e)))
            raise Exception(e)

    def close(self):
        self.client.close()


if __name__ == "__main__":
    """ 
    sample code
    """
    ssh = SshUtility("sfo-vcf01.sfo.rainpole.io", "vcf", "VMw@re123!", 22)
    ssh.connect()
    out = ssh.execute("pwd")
    print(out)

    out = ssh.execute("date")
    print(out)

    out = ssh.execute("whoami")
    print(out)

    ssh.close()

