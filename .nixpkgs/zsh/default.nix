{ writeScriptBin, zsh, zshConfig }:
  writeScriptBin "zsh" ''
    #!/bin/sh
    ZDOTDIR=${zshConfig} exec ${zsh}/bin/zsh "$@"
  ''
