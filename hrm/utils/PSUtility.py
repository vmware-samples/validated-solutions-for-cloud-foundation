import os
import subprocess
import signal


class PSUtility:

    def __init__(self, logger=None):
        self.p = None
        self.logger = logger
        if os.name == 'posix':
            pwsh = '/usr/bin/pwsh'
        else:
            pwsh = 'powershell.exe'
        self.cmd_pre = [pwsh, '-command', 'Import-Module', 'PowerValidatedSolutions', ';']

    def log_msg(self, msg):
        msg_arr = msg.split()
        for word in msg.split():
            if word.startswith('-') and 'pass' in word.lower():
                word_index = msg_arr.index(word)
                msg_arr[word_index + 1] = '********'

        msg = ' '.join(msg_arr)
        if self.logger:
            self.logger.info(msg)
        else:
            print(msg)

    def execute_ps_cmd(self, cmd):
        try:
            self.log_msg(cmd)
            full_cmd = self.cmd_pre + cmd.split(' ')
            self.p = subprocess.Popen(full_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            stdout, stderr = self.p.communicate()
            output = stdout.decode('utf-8')
            err = stderr.decode('utf-8')
            if err != '':
                self.log_msg(f'Error encountered while running command - {err}')
            self.log_msg(f'output received = {output}')
        except Exception as e:
            self.log_msg(e)
        finally:
            if not self.p:
                self.log_msg(f'Kill subprocess with id {self.p.pid}')
                try:
                    os.killpg(os.getpgid(self.p.pid), signal.SIGTERM)
                except Exception as e:
                    self.log_msg(f'error occurred while killing process {e}')


if __name__ == "__main__":
    psu = PSUtility()
    psu.execute_ps_cmd(
        'Publish-BackupStatus -server sfo-vcf01.sfo.rainpole.io -user <user> -pass <pass> '
        '-allDomains -outputJson .')
