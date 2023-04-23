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
# Helper script to perform folder operations like creating log directory, and deleting logs older than x days.
# Log location and retention period values are specified in env.json.

import os
import fnmatch
import shutil
import time
from datetime import datetime
import json

with open(os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '../env.json'))) as f:
    data = json.load(f)

DEFAULT_LOGS_DIR_PATH_LINUX = data["DEFAULT_LOGS_DIR_PATH_LINUX"]
# os.environ["HOMEDRIVE"] AND ["HOMEPATH"] will be prepended to DEFAULT_LOGS_DIR_PATH_WINDOWS
DEFAULT_LOGS_DIR_PATH_WINDOWS = data["DEFAULT_LOGS_DIR_PATH_WINDOWS"]


class FolderUtility(object):

    @staticmethod
    def get_default_log_path():
        if os.name == 'posix':
            logs_dir = DEFAULT_LOGS_DIR_PATH_LINUX
        else:
            logs_dir = os.path.join(os.environ["HOMEDRIVE"], os.environ["HOMEPATH"], DEFAULT_LOGS_DIR_PATH_WINDOWS)
        return logs_dir

    @staticmethod
    def get_log_directory():
        logs_dir = FolderUtility.get_default_log_path()
        if not os.path.exists(logs_dir):
            os.makedirs(logs_dir)
        return logs_dir

    @staticmethod
    def make_directory(path):
        """
        Make directory at given path
        """
        if not os.path.isdir(path):
            os.makedirs(path)

    @staticmethod
    def make_director_with_timestamp(path):
        dir_name = path + datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
        os.makedirs(dir_name)
        return dir_name

    @staticmethod
    def make_unique_directory(path):
        base_name = path
        count = 0
        temp_dir_name = base_name + str(count)
        while os.path.isdir(temp_dir_name):
            count += 1
            temp_dir_name = base_name + str(count)
        os.makedirs(temp_dir_name)
        return temp_dir_name

    @staticmethod
    def get_unique_file_path(path):
        base_name, ext = os.path.splitext(path)
        count = 0
        temp_file_name = base_name + str(count) + ext
        while os.path.isfile(temp_file_name):
            count += 1
            temp_file_name = base_name + str(count) + ext
        return temp_file_name

    @staticmethod
    def search_file_in_path(file_name, path):
        """
        By default it searches for .py file recursively inside given path
        file_name and path can be changed.
        Raise exception of no matches or multiple matches are found
        :return: complete path of the given file.
        """
        if '.' not in file_name:
            file_name = file_name + '.py'
        matches = []
        for root, dir_names, file_names in os.walk(path):
            for filename in fnmatch.filter(file_names, file_name):
                matches.append(os.path.join(root, filename))

        if len(matches) == 0:
            raise Exception('File not found')
        if len(matches) > 1:
            raise Exception('Multiple files found with same name')
        else:
            return matches[0]

    @staticmethod
    def delete_logs_older_than_days(days=30, logger=None):
        deleted_folders_count = 0
        deleted_files_count = 0

        path = FolderUtility.get_default_log_path()

        seconds = time.time() - (days * 24 * 60 * 60)

        if os.path.exists(path):
            for root_folder, folders, files in os.walk(path):
                for folder in folders:
                    if 'run_' in folder:
                        folder_path = os.path.join(root_folder, folder)
                        if seconds >= os.stat(folder_path).st_ctime:
                            if logger:
                                logger.info(f'Deleting {folder_path}')
                            FolderUtility.remove_folder(folder_path)
                            deleted_folders_count += 1
                # checking the current directory files
                for file in files:
                    file_path = os.path.join(root_folder, file)
                    if seconds >= os.stat(file_path).st_ctime:
                        if logger:
                            logger.info(f'Deleting {file_path}')
                        FolderUtility.remove_file(file_path)
                        deleted_files_count += 1
        else:
            if logger:
                logger.info(f'"{path}" is not found')

        if logger:
            logger.info(f"Total folders deleted: {deleted_folders_count}")

    @staticmethod
    def remove_folder(path):
        if not shutil.rmtree(path):
            print(f"{path} is removed successfully")
        else:
            print(f"Unable to delete the {path}")

    @staticmethod
    def remove_file(path):
        if not os.remove(path):
            print(f"{path} is removed successfully")
        else:
            print(f"Unable to delete the {path}")
