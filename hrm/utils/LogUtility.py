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
# Script implementing Logger class. Used for logging output to a file.

import os
import logging
import traceback
import inspect

from utils.FolderUtility import FolderUtility

"""Singleton class which wraps around python logger to log to file """

class LogUtility(object):
    __test_logger = None  # test logger which is object of this class
    __logger = None  # python logger
    test_log_folder = None

    @staticmethod
    def __get_call_info():
        stack = inspect.stack()

        # stack[1] gives previous function ('info' in our case)
        # stack[2] gives before previous function and so on

        fname = stack[2][1]  # filename
        line_num = stack[2][2]  # line num
        # func = stack[2][3]

        return os.path.basename(fname), line_num

    def __init__(self, test_suite_name, level='INFO'):
        if LogUtility.__test_logger:
            raise Exception('This is singleton class. Cannot instantiate again.')
        else:
            self.__logger = self._get_logger(test_suite_name, level)
            self.__logger.info("python logger ready")
        LogUtility.__test_logger = self

    def info(self, msg):
        fname, line_num = self.__get_call_info()
        msg = "[{}:{}] - {}".format(fname, line_num, msg)
        self.__logger.info(msg)

    def warn(self, msg):
        fname, line_num = self.__get_call_info()
        msg = "[{}:{}] - {}".format(fname, line_num, msg)
        self.__logger.warn(msg)
        self.__logger.warn(traceback.format_exc())

    def error(self, msg, trace=True):
        fname, line_num = self.__get_call_info()
        msg = "[{}:{}] - {}".format(fname, line_num, msg)
        self.__logger.error(f"Error - {msg}")
        if trace and (traceback.format_exc() != 'NoneType: None\n'):
            self.__logger.error(traceback.format_exc())

    def debug(self, msg, trace=True):
        fname, line_num = self.__get_call_info()
        msg = "[{}:{}] - {}".format(fname, line_num, msg)
        self.__logger.debug(f"Debug - {msg}")
        if trace and (traceback.format_exc() != 'NoneType: None\n'):
            self.__logger.debug(traceback.format_exc())

    @staticmethod
    def get_logger(test_suite_name=None, log_level='INFO'):
        if not LogUtility.__test_logger:
            return LogUtility(test_suite_name, level=log_level)
        else:
            return LogUtility.__test_logger

    def _get_logger(self, test_suite_name, level='INFO'):
        """default python logger"""
        accepted_levels = {'INFO': logging.INFO, 'DEBUG': logging.DEBUG}
        if level.upper() not in accepted_levels:
            raise Exception('INVALID LOG LEVEL SPECIFIED')
        logging_format = '[%(asctime)s] %(levelname)s - %(message)s'  # {%(filename)s:%(lineno)d} %(asctime)s %(levelname)s: %(message)s'
        date_format = '%Y-%m-%d %H:%M:%S'
        test_log_directory = os.path.join(FolderUtility.get_log_directory(), test_suite_name)
        FolderUtility.make_directory(test_log_directory)
        tmp_log_file_folder = os.path.join(test_log_directory, "run_")
        self.test_log_folder = FolderUtility.make_director_with_timestamp(tmp_log_file_folder)
        log_file_path = os.path.join(self.test_log_folder, "test_.log")
        test_log_path = FolderUtility.get_unique_file_path(log_file_path)
        base_name, extension = os.path.splitext(test_log_path)
        #debug_log_path = FolderUtility.get_unique_file_path(base_name + "_debug_" + extension)
        logging.basicConfig(level=logging.NOTSET, format=logging_format, datefmt=date_format)
        formatter = logging.Formatter(fmt=logging_format, datefmt=date_format)
        handler = logging.FileHandler(test_log_path)
        handler.setLevel(accepted_levels[level])
        handler.setFormatter(formatter)
        # ch = logging.StreamHandler()
        # ch.setLevel(logging.INFO)
        # ch.setFormatter(formatter)
        #debug_handler = logging.FileHandler(debug_log_path)
        #debug_handler.setLevel(logging.DEBUG)
        #debug_handler.setFormatter(formatter)
        logger = logging.getLogger("HRM")
        logger.addHandler(handler)
        # logger.addHandler(ch)
        #logger.addHandler(debug_handler)
        return logger
