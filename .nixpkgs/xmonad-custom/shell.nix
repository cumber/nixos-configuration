{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage ./default.nix {
    powerline = pkgs.powerlineWithGitStatus;
    syncthingGtk = pkgs.python27Packages.syncthing-gtk;
  };

in

  if pkgs.lib.inNixShell then drv.env else drv
