{ pkgs, ... }:
{
  imports = [
    # river compositor session
    ../modules/river-session
  
    ../modules/browser
    ../modules/emacs
    ../modules/file-manager
    ../modules/git
    ../modules/gtk-config
    ../modules/helix
    ../modules/keepassxc
    ../modules/syncthing
    ../modules/terminal
    ../modules/xcompose-maths

    # messaging services
    ../modules/element
    ../modules/signal
    ../modules/slack
    ../modules/tutanota

    # Git configurations for personal and work accounts
    ./git

    # clipboard manager
    ../modules/copyq
  ];

  home.packages = with pkgs; [
    # System
    file
    hicolor-icon-theme
    inconsolata
    psmisc
    resources
    source-code-pro
    tree

    # Devlopment
    cabal-install
    cabal2nix
    cachix
    colordiff
    graphviz
    nix-melt
    nix-tree
    jq   # awesome json pretty printer and query tool
    oq   # wrapper that can run jq on other formats, inc yaml
    pandoc

    # Office
    anki
    calibre
    clementine
    evince
    gimp
    libreoffice
    lilypond   # needed for anki plugin
    qimgv
    speedcrunch
    thunderbird
    vlc
    zoom-us

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
      "image/png" = [ "org.gnome.eog.desktop" ];
      "image/jpeg" = [ "org.gnome.eog.desktop" ];
    };
  };
}
