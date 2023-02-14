# Copyright 2017 VMware, Inc.  All rights reserved. -- VMware Confidential
# Description: Test environment setup function for EvoRack
# Disabled: True

import paramiko
import platform
import multiprocessing

from queue import Empty

__author__ = 'nalagappan'

appliance_sh_history = dict()


class SSHProcess(multiprocessing.Process):
    """
    Process object that connects to a host and runs a command over ssh.
    """

    def __init__(self, cmd, host, user, pwd, timeout=900, queue=None,
                 err_queue=None, xterm=False, ssh_key_file=None, sock=None):
        multiprocessing.Process.__init__(self)
        self.cmd = cmd
        self.host = host
        self.user = user
        self.pwd = pwd
        self.ssh_timeout = timeout  # Seconds
        self.queue = queue
        self.err_queue = err_queue
        self.ssh = paramiko.SSHClient
        self.cmd_return_code = multiprocessing.Value("i", -1)
        self.xterm = xterm
        self.ssh_key_file = ssh_key_file
        self.sock = sock

    def _find_key_type(self, key_file):
        with open(key_file, 'r') as f:
            content = f.read()
        if 'BEGIN EC' in content:
            return 'ecdsa'
        else:
            # default RSA
            return 'rsa'

    def run(self):
        """
        Override multiprocessing.Process's run() method with our own that
        executes a command over ssh.
        """
        try:
            ssh_key = None
            self.ssh = paramiko.SSHClient()
            self.ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            if self.ssh_key_file:
                key_type = self._find_key_type(self.ssh_key_file)
                try:
                    if key_type == 'ecdsa':
                        ssh_key = paramiko.ECDSAKey.from_private_key_file(
                            self.ssh_key_file)
                    else:
                        ssh_key = paramiko.RSAKey.from_private_key_file(
                            self.ssh_key_file)
                except Exception as e:
                    if self.err_queue:
                        # Workaround paramiko bug (BadAuthenticationType is not
                        # serializable)
                        self.err_queue.put(e)
                password = None
            else:
                password = self.pwd
            self.ssh.connect(hostname=self.host, username=self.user,
                             pkey=ssh_key, timeout=self.ssh_timeout,
                             password=password, banner_timeout=120, sock=self.sock)
            if self.cmd:
                self._send_command()
        except KeyboardInterrupt:
            pass
        except BrokenPipeError:
            pass
        except (paramiko.SSHException, paramiko.AuthenticationException) as e:
            if self.err_queue:
                # Workaround paramiko bug (BadAuthenticationType is not
                # serializable)
                if isinstance(e, paramiko.BadAuthenticationType):
                    e = paramiko.AuthenticationException(
                        'Host: %s %s %s - %s' % (self.host, self.user,
                                                 password, e))
                self.err_queue.put(e)
        except Exception as e:
            if self.err_queue:
                # Always convert to string in case exception is not serializable
                self.err_queue.put(Exception("%r" % e))
        finally:
            self.ssh.close()
            # Allow the process to join even when items added to queue are not
            # consumed.
            self.queue.cancel_join_thread()
            self.err_queue.cancel_join_thread()

    def _send_command(self):
        """
        Send the command to the remote host.
        """
        if platform.system() == 'Windows' and self.xterm:
            # Required when the output from ssh session is > 1000 bytes
            chan = self.ssh._transport.open_session()
            chan.get_pty('xterm')
            chan.settimeout(self.ssh_timeout)
            chan.exec_command(self.cmd, get_pty=True)
            chan.makefile('wb', -1)
            stdout = chan.makefile('rb', -1)
            stderr = chan.makefile_stderr('rb', -1)
        else:
            (stdin, stdout, stderr) = self.ssh.exec_command(self.cmd, get_pty=True)
        stdout_text = stdout.read().strip()
        stderr_text = stderr.read().strip()
        self.cmd_return_code.value = stdout.channel.recv_exit_status()

        if self.queue:
            self.queue.put(stdout_text)
        if self.err_queue:
            self.err_queue.put(stderr_text)

        # cleanup connections stream to prevent BrokenPipe error
        stdout.flush()
        stderr.flush()


class SFTPManager:
    """
    Manages remote file operations over ssh.
    """

    def __init__(self, host, user, pwd, timeout=900, queue=None,
                 err_queue=None, ssh_key_file=None):
        self.host = host
        self.user = user
        self.pwd = pwd
        self.ssh_timeout = timeout  # Seconds
        self.queue = queue
        self.err_queue = err_queue
        self.ssh = None  # paramiko.SSHClient
        self.sftp = None  # paramiko.SFTPClient
        self.ssh_key_file = ssh_key_file

    def initiate_sftp_session(self):
        """
        Initiates SSH session with host and opens up a SFTP client for use
        with file operations
        """
        try:
            self.ssh = paramiko.SSHClient()
            self.ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            if self.ssh_key_file:
                paramiko.RSAKey.from_private_key_file(self.ssh_key_file)
                self.ssh.connect(hostname=self.host, username=self.user,
                                 timeout=self.ssh_timeout, banner_timeout=120)
            else:
                self.ssh.connect(hostname=self.host, username=self.user,
                                 password=self.pwd, timeout=self.ssh_timeout,
                                 banner_timeout=120)
            self.sftp = self.ssh.open_sftp()
        except KeyboardInterrupt:
            pass
        except (paramiko.SSHException, paramiko.AuthenticationException) as e:
            if self.err_queue:
                self.err_queue.put(e)

    def make_remote_dir(self, path):
        """Makes directory in the remote host"""
        if self.sftp:
            self.sftp.mkdir(path)

    def list_remote_dir(self, path):
        """Lists the contents of remote directory"""
        remote_file_list = []
        if self.sftp:
            remote_file_list = self.sftp.listdir(path)

        return remote_file_list

    def remove_remote_dir(self, path):
        """Removes the remote directory"""
        if self.sftp:
            self.sftp.rmdir(path)

    def get_remote_file(self, remote_path, local_path):
        """Gets the remote file in the local_path specified"""
        try:
            if self.sftp:
                self.sftp.get(remote_path, local_path)
        except Exception as e:
            if self.err_queue:
                self.err_queue.put(e)

    def put_remote_file(self, local_path, remote_path):
        """Copies a local file to the remote_path specified"""
        try:
            if self.sftp:
                self.sftp.put(local_path, remote_path)
        except Exception as e:
            if self.err_queue:
                self.err_queue.put(e)

    def change_file_mode(self, filePath, mode):
        """Change the mode (permissions) of a file """
        try:
            if self.sftp:
                self.sftp.chmod(filePath, mode)
        except Exception as e:
            if self.err_queue:
                self.err_queue.put(e)

    def remove_remote_file(self, remote_path):
        """Removes a remote file"""
        try:
            if self.sftp:
                self.sftp.remove(remote_path)
        except IOError:
            pass

    def terminate_sftp_session(self):
        """Closes the SFTP session and the associated SSH session"""
        if self.sftp is not None:
            self.sftp.close()
        if self.ssh is not None:
            self.ssh.close()
        self.sftp = None
        self.ssh = None


def run_cmd_over_ssh(cmd, host, user, pwd, timeout=60, xterm=False,
                     real_rc=False, ssh_key_file=None, sock=None):
    """
    Wrapper for SSHProcess() to run a single command.
    """
    global appliance_sh_history

    prefix = 'pi shell '
    in_history = host in appliance_sh_history
    if in_history and appliance_sh_history[host]:
        cmd = prefix + cmd

    stdout_queue = multiprocessing.Queue()
    err_queue = multiprocessing.Queue()
    process = SSHProcess(cmd, host, user, pwd, timeout, stdout_queue,
                         err_queue, xterm, ssh_key_file, sock=sock)
    stdout = None
    stderr = None
    try:
        process.start()

        try:
            err = err_queue.get(True, timeout)
            if isinstance(err, Exception):
                raise err
            else:
                stderr = err
        except Empty:
            stderr = None

        try:
            stdout = stdout_queue.get(True, timeout)
        except Empty:
            stdout = None

        # The join(...) MUST BE called after all queues are consumed check this
        # from multiprocessing python 2.x documentation:
        #
        # If a child process has put items on a queue (and it has not used
        # JoinableQueue.cancel_join_thread()), then that process will not terminate
        # until all buffered items have been flushed to the pipe.
        #
        # This means that if you try joining that process you may get a deadlock
        # unless you are sure that all items which have been put on the queue have
        # been consumed.
        #
        # I hit this deadlock when the ssh command dumps a lot of info in stdout.
        process.join(timeout)
    except BrokenPipeError:
        pass
    finally:
        if process.is_alive():
            process.terminate()

    if not in_history and stdout is not None:
        if stdout.decode('utf-8').startswith('appliancesh: ') and \
                stdout.decode('utf-8').endswith(': invalid command'):
            appliance_sh_history[host] = True
            return run_cmd_over_ssh(cmd, host, user, pwd, timeout)
        else:
            appliance_sh_history[host] = False

    if real_rc:
        rc = process.cmd_return_code.value
    else:
        # XXX This is kept so the default behavior is unchanged.
        # Run it with real_rc=True to get the real return code.
        rc = process.exitcode
    return rc, stdout, stderr
