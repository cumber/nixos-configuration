{ pkgs, ... }:
{
  imports = [
    # notification daemon
    ../modules/dunst

    ../modules/alacritty
    ../modules/atuin
    ../modules/emacs
    ../modules/file-manager
    ../modules/git
    ../modules/nushell
    ../modules/xcompose-maths

    # messaging services
    ../modules/element
    ../modules/signal
    ../modules/slack

    # Git configurations for personal and work accounts
    ./git
  ];

  home.packages = with pkgs; [
    # System
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

    # Devlopment
    cabal-install
    cabal2nix
    cachix
    colordiff
    graphviz
    nix-tree
    jq   # awesome json pretty printer and query tool
    oq   # wrapper that can run jq on other formats, inc yaml
    pandoc

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

    # This causes PATH to be added to the list of variables that get
    # imported into systemd's user context, and thus get passed to
    # user services. Without this, things like slack and signal are
    # unable to open links in a browser, since they do it by xdg-open
    # which finds the browser via my profile PATH rather than via
    # direct hardcoded path.
    #
    # I'm not certain that this is okay; the importedVariables option
    # below is undocumented. I should file an issue with
    # home-manager. If it's a good idea they might want it, and if
    # it's a bad idea they can probably tell me.
    importedVariables = [ "PATH" ];
  };

  programs = {
    starship.enable = true;
    starship.settings = {
      aws.disabled = true;

      directory = {
        truncation_length = 5;
        truncation_symbol = "…/";
      };
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
