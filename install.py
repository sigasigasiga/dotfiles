#!/usr/bin/env python3

import dataclasses
import json
import logging
import os
import pathlib
import string
import sys

DESCRIPTION_FILENAME = 'description.json'

logger = logging.getLogger(__name__)

class XdgVariablesStorage:
    """
    make an absolute path according
    """
    config_home = None
    data_home = None

    @staticmethod
    def __get_xdg_env(var: str):
        ret = os.getenv(var)
        ret = ret and os.path.expanduser(ret) # NOTE: it may not be strictly according to the standard

        if ret is None:
            logger.warning('`%s` is not set', var)
        elif not os.path.isabs(ret):
            raise RuntimeError('{} must contain an absolute path'.format(var))

        return ret

    def get_config_home(self):
        def make_default():
            match os.name:
                case 'nt':
                    return os.path.expandvars('%LOCALAPPDATA%')
                case 'posix':
                    return os.path.expanduser('~/.config')
                case _:
                    raise RuntimeError('Unsupported OS `{}`'.format(os.name))

        if self.config_home is None:
            self.config_home = self.__get_xdg_env('XDG_CONFIG_HOME') or make_default()

        return self.config_home

    def get_data_home(self):
        def make_default():
            match os.name:
                case 'nt':
                    return os.path.expandvars('%LOCALAPPDATA%')
                case 'posix':
                    return os.path.expanduser('~/.local/share')
                case _:
                    raise RuntimeError('Unsupported OS `{}`'.format(os.name))

        if self.data_home is None:
            self.data_home = self.__get_xdg_env('XDG_DATA_HOME') or make_default()

        return self.data_home

    def substitute(self, tmpl: str):
        t = string.Template(tmpl)
        return t.substitute(XDG_CONFIG_HOME = self.get_config_home(), XDG_DATA_HOME = self.get_data_home())

xdg_variables = XdgVariablesStorage()

class TargetMap:
    map = None

    def __init__(self, description_path: pathlib.Path):
        if os.path.isfile(description_path):
            with open(description_path) as description_file:
                self.map = json.load(description_file)

    def get_target_path(self, target: str):
        target_info = self.map and self.map.get(target)
        target_info = target_info and target_info.get(os.name, target_info)

        path = target_info and target_info.get("path")
        path = path and xdg_variables.substitute(path)
        path = path or xdg_variables.get_config_home()
        if not type(path) == str:
            raise ValueError("`path` must be a string or it shouldn't exist")

        filename = target_info and target_info.get("as")
        filename = filename or target
        if not type(filename) == str:
            raise ValueError("`filename` must be a string or it shouldn't exist")

        return pathlib.Path(path) / filename

def main():
    if len(sys.argv) < 2:
        raise RuntimeError('No arg was given')

    program_name = sys.argv[1]

    current_dir = pathlib.Path('.')
    config_dir = current_dir / program_name
    description_path = config_dir / DESCRIPTION_FILENAME
    target_map = TargetMap(description_path)

    for ent in os.listdir(config_dir):
        if ent == DESCRIPTION_FILENAME:
            continue

        logger.info('%s', ent)

        path = target_map.get_target_path(ent)
        logger.info('creating directories %s', path.parent)
        logger.info('symlinking %s to %s', config_dir / ent, path)
        #os.makedirs(path.parent, mode = 0o700, exist_ok = True)
        #os.symlink(config_dir / ent, path)

if __name__ == '__main__':
    try:
        main()
    except BaseException as e:
        logger.error('Error: %s', e)

