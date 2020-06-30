{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage ./xmonad-custom.nix {};

  env = nixpkgs.buildEnv {
    name = "extra-development-tools";
    paths = [ haskellPackages.ghcide ];
  };

in
  nixpkgs.stdenv.mkDerivation rec {
    name = "xmonad-dev";

    # drv.env is a useless build that just writes a file containing paths
    # to the Haskell infrastructure necessary to build drv. It's intended
    # to be used as the basis for a nix shell, which will make its
    # dependencies available. Since we want to add our own environment,
    # we need to include not drv or drv.env, but all of drv.env's
    # buildInputs.
    buildInputs = drv.env.buildInputs or [] ++ [ env ];
    nativeBuildInputs = drv.env.nativeBuildInputs or [];
    propagatedBuildInputs = drv.env.propagatedBuildInputs or [];
    propagatedNativeBuildInputs = drv.env.propagatedNativeBuildInputs or [];

    buildCommand = ''
      echo "${drv.env}" >> $out
      echo "${env}" >> $out
    '';
  }
