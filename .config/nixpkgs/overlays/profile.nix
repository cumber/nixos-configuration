self: super: {
  profile = with self; super.buildEnv {
    name = "profile";
    paths = [
      # System
      blueman
      gnome3.adwaita-icon-theme  # fallback icons from numix
      gnome3.gnome-system-monitor
      hicolor_icon_theme
      inconsolata
      lxappearance
      nixos-config
      numix-gtk-theme
      numix-icon-theme
      psmisc
      syncthing-gtk
      source-code-pro
      taffybar
      termite
      tree
      xmonad-custom
      xsel
      zdotdir

      # Devlopment
      cabal-install
      cabal2nix
      colordiff
      emacs-custom
      emacs-edit
      gitAndTools.gitFull
      haskellPackages.hasktags
      haskellPackages.hlint
      nox
      powerlineWithGitStatus
      powerline-fonts

      # Office
      chromium
      evince
      gimp
      gnome3.eog
      libreoffice
      rhythmbox
      speedcrunch
      thunderbird
      vlc

      chatty

      # LyX / LaTeX
      lyx
      (texlive.combine {
        inherit (texlive)
          collection-fontsrecommended
          collection-latex
          collection-latexrecommended

          paralist
        ;
      })
    ];
  };
}
