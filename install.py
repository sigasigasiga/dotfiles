#!/usr/bin/env python3

import logging
import os
import pathlib
import subprocess
import sys

from target_map import TargetMap

logger = logging.getLogger(__name__)

def update_submodules(path: pathlib.Path):
    return subprocess.call(['git', 'submodule', 'update', '--init', '--recursive', '--', str(path)])

def main():
    logging.basicConfig(level = logging.DEBUG)

    if len(sys.argv) < 2:
        raise RuntimeError('No arg was given')

    config_dir = pathlib.Path(sys.argv[1]).resolve()
    if (ec := update_submodules(config_dir)) != 0:
        logger.warning('Cannot update the submodules: %d', ec)

    target_map = TargetMap(config_dir)

    for ent in os.listdir(config_dir):
        if path := target_map.get_target_path(ent):
            logger.info('Creating directories `%s`', path.parent)
            logger.info('Symlinking `%s` to `%s`', config_dir / ent, path)

            try:
                os.makedirs(path.parent, mode = 0o700, exist_ok = True)
                os.symlink(config_dir / ent, path)
            except Exception as  e:
                logger.warning('Cannot install `%s`: %s', ent, str(e))

if __name__ == '__main__':
    try:
        main()
    except Exception:
        logging.exception('Got an exception. Aborting...')
