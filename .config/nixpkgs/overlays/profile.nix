self: super: {
  profile = with self; super.buildEnv {
    name = "profile";
    paths = [
      # System
      file
      gnome3.adwaita-icon-theme  # fallback icons from numix
      gnome3.gnome-system-monitor
      gnome3.nautilus
      hicolor_icon_theme
      inconsolata
      lxappearance
      nixos-config
      numix-cursor-theme
      numix-gtk-theme
      numix-icon-theme
      numix-icon-theme-square   # application icons
      psmisc
      syncthing-gtk
      source-code-pro
      termite
      tree
      xmonad-custom
      xmonad-session-init
      xsel
      zdotdir

      # Devlopment
      cabal-install
      cabal2nix
      colordiff
      emacs-custom
      emacs-edit
      gitAndTools.gitFull
      #haskellPackages.hasktags
      haskellPackages.hlint
      nodePackages.tern   # used by js mode setup in emacs
      nox
      powerlineWithGitStatus
      powerline-fonts

      # Office
      firefox
      chromium
      evince
      keepassxc
      gimp
      gnome3.eog
      libreoffice
      lollypop
      signal-desktop
      slack
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
