{ pkgs, ... }:
{
  imports = [
    # notification daemon
    ../modules/dunst

    ../modules/emacs
    ../modules/file-manager
    ../modules/git

    # messaging services
    ../modules/signal
    ../modules/slack
  ];

  home.packages = with pkgs; [
    # System
    alacritty-configured
    file
    gnome.adwaita-icon-theme  # fallback icons from numix
    gnome.gnome-system-monitor
    gwe  # fan control for GPU
    hicolor-icon-theme
    inconsolata
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
    graphviz
    nix-tree
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
    gnome.eog
    libreoffice
    lilypond   # needed for anki plugin
    speedcrunch
    thunderbird
    vlc
    zoom-us

    chatty

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

    ".cabal/config".source = ./config/haskell/config.cabal;
    ".ghc/ghci.conf".source = ./config/haskell/ghci.conf;

    ".pythonrc".source = ./config/pythonrc.py;

    ".ssh/config".source = ./config/ssh.config;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
      "application/json" = [ "emacsclient.desktop" "emacs.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
    };
  };

  xdg.configFile = {
    "albert" = {
      source = ./config/albert;
      recursive = true;
    };
  };
}
