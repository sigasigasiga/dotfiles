import enum
import json
import logging
import os
import pathlib
import re
import typing

DESCRIPTION_FILENAME: typing.Final[str] = 'description.json'

_logger = logging.getLogger(__name__)

class Kind(enum.Enum):
    COMMON = 'common'
    PLATFORM_SPECIFIC = 'platform-specific'

def read_description_file(file_path: pathlib.Path) -> typing.Any:
    try:
        with open(file_path) as description_file:
            return json.load(description_file)
    except FileNotFoundError as e:
        _logger.info('Description file `%s` does not exist', str(e))
        return {}

def get_filename(kind: Kind):
    match kind:
        case Kind.COMMON:
            return DESCRIPTION_FILENAME
        case Kind.PLATFORM_SPECIFIC:
            return f'description.{os.name}.json'

    raise RuntimeError(f'Unsupported description kind `{kind}`')

def is_description_file(filename: str) -> bool:
    return filename == DESCRIPTION_FILENAME or bool(re.match(r'description\..*\.json', filename))

def read_description(config_dir: pathlib.Path) -> typing.Any:
    platform_desc_filename = config_dir / get_filename(Kind.PLATFORM_SPECIFIC)
    platform_desc = read_description_file(platform_desc_filename)
    merge = platform_desc.get('$merge')
    if platform_desc and not isinstance(merge, bool):
        raise RuntimeError(f'invalid type of `$merge` flag in `{platform_desc_filename}`')

    if merge:
        return read_description_file(config_dir / DESCRIPTION_FILENAME) | platform_desc
    else:
        return platform_desc
