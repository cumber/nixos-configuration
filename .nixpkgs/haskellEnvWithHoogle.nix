{
  nixpkgs ? import <nixpkgs> {},
  compiler ? "default",
  withHoogle ? true,
  packagePath
}:

let inherit (nixpkgs) pkgs;

    packageSet = (
      if compiler == "default"
        then  pkgs.haskellPackages
        else  pkgs.haskell.packages.${compiler}
    );

    haskellPackages = (
      if withHoogle
        then  packageSet.override {
                overrides = (self: super:
                  {
                    ghc = super.ghc // { withPackages = super.ghc.withHoogle; };
                    ghcWithPackages = self.ghc.withPackages;
                  }
                );
              }
        else  packageSet
    );

    drv = haskellPackages.callPackage (import packagePath) {};

in  drv.env
