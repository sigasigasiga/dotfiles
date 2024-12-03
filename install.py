import json
import os
import pathlib
import sys

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

def main():
    if len(sys.argv) < 2:
        raise RuntimeError('No arg was given')

    program_name = sys.argv[1]

    current_dir = pathlib.Path('.')
    config_dir = current_dir / program_name

    xdg_config_home = os.getenv('XDG_CONFIG_HOME') or default_config_home()
    xdg_data_home = os.getenv('XDG_DATA_HOME') or default_data_home()

    with open('./config.json') as cfg_file:
        cfg = json.load(cfg_file)


main()
