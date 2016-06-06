{ stdenv, coreutils, vte, writeScript }:
  derivation {
    name = "zsh-config";
    system = stdenv.system;

    builder = writeScript "zsh-config-builder" ''
      #!${stdenv.shell}

      PATH=${coreutils}/bin

      mkdir -p $out
      echo "source ${vte}/etc/profile.d/vte.sh" | cat ${./zshrc} - > $out/.zshrc
      cp ${./zshenv} $out/.zshenv
    '';
  }
