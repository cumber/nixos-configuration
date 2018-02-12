{ stdenv, coreutils, vte, zsh }:
  zsh.overrideDerivation (super: {
    preConfigure = super.preConfigure + ''
      configureFlags="$configureFlags --enable-etcdir=$out/etc"
    '';

    postInstall = super.postInstall + ''
      echo "ZDOTDIR=$out/etc/zdotdir" > $out/etc/zshenv

      mkdir -p $out/etc/zdotdir
      cp ${./zshenv} $out/etc/zdotdir/.zshenv
      echo "source ${vte}/etc/profile.d/vte.sh" | cat ${./zshrc} - > $out/etc/zdotdir/.zshrc
    '';
  })
