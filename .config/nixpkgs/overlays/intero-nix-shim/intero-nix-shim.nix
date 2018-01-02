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
    rev = "8ef83a34dfd0f7a23b2f171047750a6fb8cade3a";
    sha256 = "0zqkhrrh9i6y5ik34ilc10ixj65cpczcw2429ji1ybadlwrb3k4c";
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
