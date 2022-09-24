{ pkgs, ... }:
let emacs-config = pkgs.substituteAll {
      src = ./init.el;

      # Emacs config for javascript mode needs nodejs, but I don't
      # want it in my profile directly
      inherit (pkgs) nodejs;
    };

    # launcher script for using emacs client
    ee = pkgs.writeShellScriptBin "ee" ''
      if [[ $IN_NIX_SHELL = "" ]]; then
        socketName="default"
      else
        socketName="nix-shell: $name"
      fi

      emacsclient \
        --socket-name "$socketName" \
        --alternate-editor "" \
        --create-frame \
        --no-wait \
        "$@"
    '';
in
{
  programs.emacs = {
    enable = true;
    package = pkgs.emacs-gtk;

    extraConfig = builtins.readFile emacs-config;
    extraPackages = (epkgs: with epkgs; [
      # foundation of package config in emacsd/init.el
      use-package

      ###
      # General editor behaviour
      ###

      # code checking in editor
      flycheck

      # company (code-completion) front end with icons
      company-box

      # fuzzy matching in company code-completion
      company-flx

      # project interaction library for Emacs
      projectile

      # Ivy completion for Emacs commands
      ivy
      ivy-hydra

      # extended search command
      swiper

      # Ivy completion support in projectile
      counsel-projectile

      # Ivy interface to workspace symbols in LSP
      lsp-ivy

      # Infer indentation offset from file contents
      dtrt-indent

      # draw line at suggested max line width
      fill-column-indicator

      # show relative line numbers
      linum-relative

      # rainbow colouring for brackets
      rainbow-delimiters

      # Tree layout file explorer
      treemacs
      lsp-treemacs

      # show completion for multi-step key bindings
      which-key


      #####
      # Language support
      #####

      # haskell language support
      haskell-mode
      company-cabal
      lsp-haskell
      lsp-ui
      yasnippet

      csv-mode

      dockerfile-mode
      docker-compose-mode

      graphviz-dot-mode

      # JavaScript
      tide
      js2-mode

      php-mode

      markdown-mode

      nginx-mode

      nix-mode
      nix-sandbox

      # git support
      diff-hl
      magit

      # ruby language support
      robe

      # HTML mode with support for embedded parts in other languages
      # (for CSS, script tags, and templating engines in PHP, Python, etc)
      web-mode

      yaml-mode
    ]);
  };

  home.packages = [
    ee

    # used by js mode setup in emacs
    pkgs.nodePackages.tern
  ];
}
