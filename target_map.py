import logging
import os
import pathlib
import typing

import description
import xdg_variables_storage

logger = logging.getLogger(__name__)

xdg_variables = xdg_variables_storage.XdgVariablesStorage()

"""
If `k` exists in `m` and its value is `None`, throw `TargetIsSkippedError`
If `k` does not exist in `m`, return `None`
If `m` is `None`, return `None`
Otherwise, return `m[k]`
"""
def get_skippable(m: typing.Any, k: typing.Any):
    if m is None:
        return None

    try:
        ret = m[k]
        if ret is None:
            raise TargetIsSkippedError(f'`{k}` key is set to `null`')
        else:
            return ret
    except KeyError:
        return None

def is_ignored(filename: str) -> bool:
    IGNORE_FILES = frozenset(['.gitignore'])
    return filename in IGNORE_FILES or description.is_description_file(filename)

class TargetIsSkippedError(Exception):
    pass

class TargetMap:
    desc: None | typing.Any = None

    def __init__(self, config_dir: pathlib.Path):
        self.desc = description.read_description_dir(config_dir)

    def get_target_path(self, target: str) -> pathlib.Path | None:
        if is_ignored(target):
            return None

        try:
            desc = self.desc
            target_info = get_skippable(desc, target) or get_skippable(desc, '*')

            path = target_info and target_info.get('path') # `"path": null` stands for default
            if not isinstance(path, None | str):
                raise ValueError('`path` must be a `string` or `None`, got {}', type(path))
            path = path and xdg_variables.substitute(path)
            path = path and os.path.expanduser(path)
            path = path or xdg_variables.get_config_home()

            filename = target_info and target_info.get('as') # `"as": null` stands for default
            if not isinstance(filename, None | str):
                raise ValueError('`filename` must be a string or `None`, got {}', type(filename))
            filename = filename or target

            return pathlib.Path(path) / filename
        except TargetIsSkippedError as e:
            logger.info('Target `%s` is explicitly skipped: %s', target, e)
            return None

