#!/usr/bin/env python

"""
NDA - nix development activate
"""

import argparse
import glob
import os
import subprocess
import sys


def file_exists_mtime(path, follow_symlinks=False):
    if follow_symlinks:
        stat = os.stat
    else:
        stat = os.lstat
    try:
        return stat(path).st_mtime
    except OSError:
        return None


def instantiate(drv, default, shell, haskell_shell=False, force=False):
    drv = os.path.abspath(drv)

    drv_mtime, default_mtime, shell_mtime = \
        map(file_exists_mtime, [drv, default, shell])

    instantiate_args = ['nix-instantiate']
    if haskell_shell and default_mtime is not None and shell_mtime is None:
        instantiate_args.extend([
            '--expr',
            'with import <nixpkgs> {}; '
                'haskellEnvWithHoogle { packagePath = ' + default + '; }',
        ])
        nix_mtime = default_mtime
    else:
        if shell_mtime is not None:
            nix = shell
            nix_mtime = shell_mtime
        else:
            nix = default
            nix_mtime = default_mtime
        instantiate_args.append(nix)

    instantiate_args.extend(['--add-root', drv, '--indirect'])

    if force or drv_mtime is None or (nix_mtime and drv_mtime < nix_mtime):
        subprocess.check_call(instantiate_args)


def launch(drv, command):
    shell_args = ['nix-shell', os.path.abspath(drv)]
    if command:
        shell_args.extend(['--command', command])

    os.execvp('nix-shell', shell_args)


def main(raw_args):
    parser = argparse.ArgumentParser(epilog=__doc__)

    parser.add_argument(
        '--instantiate', action='store_true', default=False,
        help="Only instantiate the environment to a shell.drv (do not load it)"
    )

    parser.add_argument(
        'path', default='.', nargs='?',
        help="Path to folder where an environment is configured"
    )

    parser.add_argument(
        '-c', '--command', default='zsh',
        help="Command to run as shell; empty string uses nix build shell"
    )

    args = parser.parse_args(raw_args)

    path = args.path

    shell_nix, default_nix, shell_drv = (
        os.path.join(path, f)
        for f in ('shell.nix', 'default.nix', 'shell.drv')
    )

    is_cabal = bool(glob.glob(os.path.join(path, '*.cabal')))

    instantiate(shell_drv, default_nix, shell_nix, haskell_shell=is_cabal)

    if not args.instantiate:
        launch(shell_drv, command=args.command)


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
