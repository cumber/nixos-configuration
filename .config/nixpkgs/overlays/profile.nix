self: super: {
  profile = with self; super.buildEnv {
    name = "profile";
    paths = [
      # System
      alacritty-configured
      bibata-extra-cursors
      file
      gnome3.adwaita-icon-theme  # fallback icons from numix
      gnome3.gnome-system-monitor
      gnome3.nautilus
      hicolor_icon_theme
      inconsolata
      lxappearance
      nixos-config
      numix-gtk-theme
      numix-icon-theme
      numix-icon-theme-square   # application icons
      psmisc
      syncthing-gtk
      source-code-pro
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

      # Office
      firefox
      chromium
      anki
      clementine
      evince
      keepassxc
      gimp
      gnome3.eog
      libreoffice
      lilypond   # needed for anki plugin
      signal-desktop
      speedcrunch
      thunderbird
      vlc

      chatty

      fahcontrol
      fahviewer

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
