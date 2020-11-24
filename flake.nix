{
  description = "Cumber's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    desktop = {
      url = "path:packages/desktop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alacritty-configured = {
      url = "path:packages/alacritty-configured";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chatty = {
      url = "path:packages/chatty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-custom = {
      url = "path:packages/emacs-custom";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zdotdir = {
      url = "path:packages/zdotdir";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-haskell = {
      url = "path:packages/zsh-haskell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, desktop,
              alacritty-configured, chatty, emacs-custom,
              zdotdir, zsh-haskell
            }:
    let lib = import ./lib.nix { inherit (nixpkgs) lib; };

        machines = lib.genAttrs (lib.readSubDirs ./system/machines) makeConfig;

        makeConfig = (name:
          nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              home-manager.nixosModules.home-manager
              (import ./system/modules/common.nix)
              (import (./system/machines + "/${name}"))
              (import (./system/machines + "/${name}/hardware-configuration.nix"))
            ];
            pkgs = import nixpkgs {
              inherit system;

              overlays = builtins.concatLists [
                desktop.overlays
                alacritty-configured.overlays
                chatty.overlays
                emacs-custom.overlays
                zdotdir.overlays
                zsh-haskell.overlays
              ];

              config = {
                allowUnfreePredicate = (pkg:
                  builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) [
                    "nvidia-x11"
                    "nvidia-settings"
                    "nvidia-persistenced"
                    "fahclient"
                    "fahcontrol"
                    "fahviewer"
                  ]
                );
              };
            };
          }
        );
    in {
      nixosConfigurations = machines;
    };
}
