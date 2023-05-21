{
  description = "Cumber's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Taffybar frequently coredumps when running on newer Linux kernels!
    # This seems to ultimately be a Linux kernel bug, but building with
    # GHC 9.4 avoids it.
    # See https://github.com/taffybar/taffybar/issues/561
    #
    # However Taffybar as in nixpkgs doesn't build with GHC 9.4, so
    # use this flake temporarily to fix it. *That* issue seems to be
    # a Cabal problem. So we should be able to get rid of this once
    # https://github.com/haskell/cabal/issues/8455 is fixed (and makes
    # it into nixpkgs).
    taffybar.url = "github:taffybar/taffybar/master";
  };

  outputs = { self, nixpkgs, home-manager, taffybar }:
    let lib = import ./lib.nix { inherit (nixpkgs) lib; };

        machines = lib.genAttrs (lib.readSubDirs ./system/machines) makeConfig;

        findAndImportOverlays = lib.composeAll [
          (map import)
          (lib.filter (p: baseNameOf p == "overlay.nix"))
          lib.filesystem.listFilesRecursive
        ];

        makeNixPath = (name: [
          "nixpkgs=${nixpkgs}"
          "repl=${nixpkgs.outputs.legacyPackages.x86_64-linux.writeText "repl" ''
            let flake = builtins.getFlake "${./.}";
                pkgs = flake.nixosConfigurations.${name}.pkgs;
             in { inherit flake; }
                  // flake
                  // builtins
                  // pkgs
                  // pkgs.lib
                  // flake.nixosConfigurations
          ''}"
        ]);

        makeConfig = (name:
          nixpkgs.lib.nixosSystem rec {
            system = "x86_64-linux";
            modules = [
              home-manager.nixosModules.home-manager
              ({ ... }: {
                nix.registry.nixpkgs.flake = nixpkgs;
                nix.nixPath = makeNixPath name;
              })
              (import ./system/modules/common.nix)
              (import (./system/machines + "/${name}"))
              (import (./system/machines + "/${name}/hardware-configuration.nix"))
            ];
            pkgs = import nixpkgs {
              inherit system;

              overlays = (
                findAndImportOverlays ./overrides
                ++ findAndImportOverlays ./packages
                ++ taffybar.overlays
              );

              config = {
                allowUnfreePredicate = (pkg:
                  builtins.elem (pkg.pname or (builtins.parseDrvName pkg.name).name) [
                    "nvidia-x11"
                    "nvidia-settings"
                    "nvidia-persistenced"
                    "cudatoolkit"

                    "slack"

                    "zoom"
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
