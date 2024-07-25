{
  description = "Cumber's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wired-notify = {
      url = "github:Toqozz/wired-notify";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, wired-notify, rust-overlay }:
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
                home-manager.sharedModules = [
                  wired-notify.homeManagerModules.default
                ];
              })
              (import ./system/modules/common.nix)
              (import (./system/machines + "/${name}"))
              (import (./system/machines + "/${name}/hardware-configuration.nix"))
            ];
            pkgs = import nixpkgs {
              inherit system;

              overlays = (
                findAndImportOverlays ./overrides
                ++ [ wired-notify.overlays.default ]
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
