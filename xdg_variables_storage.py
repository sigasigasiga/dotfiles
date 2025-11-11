import logging
import os
import string

__logger = logging.getLogger(__name__)

class XdgVariablesStorage:
    __config_home = None
    __data_home = None

    @staticmethod
    def __get_xdg_env(var: str):
        ret = os.getenv(var)

        if ret is None:
            __logger.warning('`%s` is not set', var)
        elif not os.path.isabs(ret):
            raise RuntimeError(f'{var} must contain an absolute path')

        return ret

    def get_config_home(self):
        def make_default():
            match os.name:
                case 'nt':
                    return os.path.expandvars('%LOCALAPPDATA%')
                case 'posix':
                    return os.path.expanduser('~/.config')
                case _:
                    raise RuntimeError(f'Unsupported OS `{os.name}`')

        if self.__config_home is None:
            self.__config_home = self.__get_xdg_env('XDG_CONFIG_HOME') or make_default()

        return self.__config_home

    def get_data_home(self):
        def make_default():
            match os.name:
                case 'nt':
                    return os.path.expandvars('%LOCALAPPDATA%')
                case 'posix':
                    return os.path.expanduser('~/.local/share')
                case _:
                    raise RuntimeError(f'Unsupported OS `{os.name}`')

        if self.__data_home is None:
            self.__data_home = self.__get_xdg_env('XDG_DATA_HOME') or make_default()

        return self.__data_home

    def substitute(self, tmpl: str):
        t = string.Template(tmpl)
        # TODO: evaluate variables lazily
        return t.substitute(XDG_CONFIG_HOME = self.get_config_home(), XDG_DATA_HOME = self.get_data_home())

