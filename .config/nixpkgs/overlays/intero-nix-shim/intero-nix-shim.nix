{ mkDerivation, base, cabal-install, directory, fetchFromGitHub
, filepath, intero, optparse-applicative, posix-escape, split
, stdenv, unix
}:
mkDerivation {
  pname = "intero-nix-shim";
  version = "0.1.2.patch";
  src = fetchFromGitHub {
    owner = "cumber";
    repo = "intero-nix-shim";
    rev = "a4fb940ace8e039d522fa0eb59dfef4504af89f3";
    sha256 = "157xccaa350y44h46sv613b0m1jrjgpsh31wbbz3b9w2qnazhvfh";
  };
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base directory filepath optparse-applicative posix-escape split
    unix
  ];
  postInstall = ''
    mkdir -p $out/libexec
    ln -s ${cabal-install}/bin/cabal  $out/libexec
    ln -s ${intero       }/bin/intero $out/libexec
  '';
  homepage = https://github.com/michalrus/intero-nix-shim;
  license = stdenv.lib.licenses.asl20;
}
