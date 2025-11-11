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

def get_filename(kind: Kind):
    match kind:
        case Kind.COMMON:
            return DESCRIPTION_FILENAME
        case Kind.PLATFORM_SPECIFIC:
            return f'description.{os.name}.json'

    raise RuntimeError(f'Unsupported description kind `{kind}`')

def read_description_file(config_dir: pathlib.Path, kind: Kind) -> typing.Any:
    try:
        with open(config_dir / get_filename(kind)) as description_file:
            return json.load(description_file)
    except FileNotFoundError as e:
        _logger.info('Description file `%s` does not exist', str(e))
        return {}

def is_description_file(filename: str) -> bool:
    return filename == DESCRIPTION_FILENAME or bool(re.match(r'description\..*\.json', filename))

def read_description_dir(config_dir: pathlib.Path) -> typing.Any:
    platform_desc = read_description_file(config_dir, Kind.PLATFORM_SPECIFIC)

    if platform_desc:
        merge = platform_desc.get('$merge')
        if not isinstance(merge, bool):
            raise RuntimeError(f'invalid type of `$merge` flag in `{Kind.PLATFORM_SPECIFIC}`')

        if merge:
            return read_description_file(config_dir, Kind.COMMON) | platform_desc
        else:
            return platform_desc
    else:
        return read_description_file(config_dir, Kind.COMMON)
