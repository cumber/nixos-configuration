{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage ./xmonad-custom.nix {
    powerline = pkgs.powerlineWithGitStatus;
    slack = pkgs.slack;  # clash with haskellPackages.slack
  };

in

  if pkgs.lib.inNixShell then drv.env else drv
