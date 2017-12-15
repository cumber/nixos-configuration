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
    rev = "ee504e490093567c4b1c122dc45358419d451fb5";
    sha256 = "07vsqr9cf6n2r7zzb5w3dy78adii9ghknz7476lhlgfv4g6nwx74";
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
