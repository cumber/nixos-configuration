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
    rev = "a4dff59919e8a072ea6e3277ee6e4b2328fefba4";
    sha256 = "1337mdcp1d8m6kgjh8r81raiwjflip1b19ci6vyi7y11z53y0nv7";
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
