import json
import logging
import os
import pathlib
import string
import sys

DESCRIPTION_FILENAME = 'description.json'

logger = logging.getLogger(__name__)

def default_config_home():
    match os.name:
        case 'nt':
            return os.path.expandvars('%LOCALAPPDATA%')
        case 'posix':
            return os.path.expanduser('~/.config')

    raise RuntimeError('Unsupported OS')

def default_data_home():
    match os.name:
        case 'nt':
            return os.path.expandvars('%LOCALAPPDATA%')
        case 'posix':
            return os.path.expanduser('~/.local/share')

    raise RuntimeError('Unsupported OS')

def get_xdg_env(var: str):
    ret = os.getenv(var)

    if ret is None:
        logger.warning('`%s` is not set', var)
    else:
        ret = os.path.expanduser(ret) # it may not be strictly according to the standard
        if not os.path.isabs(ret):
            raise RuntimeError('{} must contain an absolute path'.format(var))

    return ret

# TODO: evaluate them lazily
xdg_config_home = get_xdg_env('XDG_CONFIG_HOME') or default_config_home()
xdg_data_home = get_xdg_env('XDG_DATA_HOME') or default_data_home()

def expand_path(path: str):

    return string.Template(path).substitute(XDG_CONFIG_HOME=xdg_config_home, XDG_DATA_HOME=xdg_data_home)

class TargetMap:
    def __init__(self, description_path):
        if os.path.isfile(description_path):
            with open(description_path) as description_file:
                self.map = json.load(description_file)
        else:
            self.map = None

    def get_target_path(self, target: str):
        if self.map is None:
            # TODO: code duplication
            return xdg_config_home
        else:
            # TODO: `self.map[target]` may be a string or an object
            return self.map[target]

def main():
    if len(sys.argv) < 2:
        raise RuntimeError('No arg was given')

    program_name = sys.argv[1]

    current_dir = pathlib.Path('.')
    config_dir = current_dir / program_name
    description_path = config_dir / DESCRIPTION_FILENAME

    print(TargetMap(description_path).get_target_path('foo'))
    print(TargetMap('zathura').get_target_path('foo'))

if __name__ == '__main__':
    # TODO: handle exceptions
    main()
