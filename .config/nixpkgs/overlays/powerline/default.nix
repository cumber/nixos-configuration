self: super: {
  powerline-gitstatus = self.pythonPackages.callPackage ./powerline-gitstatus.nix {};
  powerlineWithGitStatus = self.pythonPackages.powerline.overrideDerivation (old: {
    propagatedBuildInputs = (
      [ self.powerline-gitstatus ]
      ++ builtins.filter (dep: dep != self.bazaar) old.propagatedBuildInputs
    );
  });
}
