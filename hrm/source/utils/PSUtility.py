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
# Helper script to run health checks and get data from the SOS Utility running on SDDC Manager.


import os
import subprocess
import signal
import shutil


class PSUtility:

    def __init__(self, logger=None):
        self.p = None
        self.logger = logger
        if os.name == 'posix':
            pwsh = '/usr/bin/pwsh'
        else:
            pwsh = 'pwsh.exe' if shutil.which('pwsh.exe') else 'powershell.exe'
        self.log_msg(f'Running PowerShell cmdlets using {pwsh}')
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
