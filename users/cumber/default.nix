{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
    numix-gtk-theme
    numix-icon-theme
    numix-icon-theme-square   # application icons
    psmisc
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

    # Folding@Home
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

  services.syncthing.enable = true;

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";

    numlock.enable = true;
    preferStatusNotifierItems = true;
    windowManager.command  = "${pkgs.xmonad-custom}/bin/launch-xmonad";
  };

  home.file = {
    ".colordiffrc".source = ./config/colordiffrc;

    ".emacs.d" = {
      source = ./config/emacs;
      recursive = true;
    };

    ".gitconfig".source = ./config/git/gitconfig;
    ".gitglobalignore".source = ./config/git/gitglobalignore;

    ".gtkrc-2.0".source = ./config/gtk/gtk2-settings;

    ".cabal/config".source = ./config/haskell/config.cabal;

    ".pythonrc".source = ./config/pythonrc.py;

    ".ssh/config".source = ./config/ssh.config;
  };

  xdg.configFile = {
    "albert" = {
      source = ./config/albert;
      recursive = true;
    };

    "gtk-3.0/settings.ini".source = ./config/gtk/gtk3-settings.ini;

    ".ghci".source = ./config/haskell/config.ghci;

    "starship.toml".source = ./config/starship.toml;
  };
}
