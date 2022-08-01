{ pkgs, ... }:
{
  imports = [
    ../modules/slack.nix
    ../modules/git.nix
  ];

  home.packages = with pkgs; [
    # System
    alacritty-configured
    bibata-extra-cursors
    file
    gnome3.adwaita-icon-theme  # fallback icons from numix
    gnome3.gnome-system-monitor
    gwe  # fan control for GPU
    hicolor-icon-theme
    inconsolata
    pcmanfm
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
    graphviz
    #haskellPackages.hasktags
    haskellPackages.hlint
    nodePackages.tern   # used by js mode setup in emacs
    jq   # awesome json pretty printer and query tool
    oq   # wrapper that can run jq on other formats, inc yaml

    # Office
    firefox
    chromium
    anki
    calibre
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
    zoom-us

    chatty

    # Folding@Home
    fahcontrol
    fahviewer

    guitarix

    # LyX / LaTeX
    lyx
    (texlive.combine {
      inherit (texlive)
        collection-fontsrecommended
        collection-latex
        collection-latexrecommended

        paralist

        invoice2
        siunitx  # required by invoice2
        translations
      ;
    })
  ];

  services = {
    network-manager-applet.enable = true;

    syncthing.enable = true;

    # Starting watcher explicitly works better than letting taffybar
    # start it
    status-notifier-watcher.enable = true;
    taffybar = {
      enable = true;
      package = pkgs.xmonad-custom;
    };
  };

  xsession = {
    enable = true;
    scriptPath = ".hm-xsession";

    numlock.enable = true;
    preferStatusNotifierItems = true;
    windowManager.command  = "${pkgs.xmonad-custom}/bin/xmonad";
  };

  programs = {
    starship.enable = true;
    starship.settings = {
      aws.disabled = true;
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "TeX Gyre Schola";
      size = 12;
    };
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-icon-theme;
    };
    theme = {
      name = "Numix";
      package = pkgs.numix-gtk-theme;
    };
  };

  home.stateVersion = "22.05";

  home.file = {
    ".colordiffrc".source = ./config/colordiffrc;

    ".emacs.d/init.el" = {
      source = pkgs.substituteAll {
        src = ./config/emacs/init.el;

        # Emacs config for javascript mode needs nodejs, but I don't
        # want it in my profile directly
        inherit (pkgs) nodejs;
      };
    };

    #".gtkrc-2.0".source = ./config/gtk/gtk2-settings;

    ".cabal/config".source = ./config/haskell/config.cabal;

    ".pythonrc".source = ./config/pythonrc.py;

    ".ssh/config".source = ./config/ssh.config;
  };

  xdg.configFile = {
    "albert" = {
      source = ./config/albert;
      recursive = true;
    };

    #"gtk-3.0/settings.ini".source = ./config/gtk/gtk3-settings.ini;

    ".ghci".source = ./config/haskell/config.ghci;
  };
}
