{ stdenv, coreutils, vte, zsh, writeScript }:
  zsh.overrideDerivation (super: {
    preConfigure = super.preConfigure + ''
      configureFlags="$configureFlags --enable-etcdir=$out/etc"
    '';

    postInstall = super.postInstall + ''

      echo "ZDOTDIR=$out/zdotdir" > $out/etc/zshenv

      mkdir -p $out/zdotdir
      echo "source ${vte}/etc/profile.d/vte.sh" | cat ${./zshrc} - > $out/zdotdir/.zshrc
      cp ${./zshenv} $out/zdotdir/.zshenv
    '';
  })
