{ mkDerivation, fetchgit, base, containers, ghc, ghc-tcplugins-extra
, simple-smt, stdenv, z3-exe
}:
mkDerivation {
  pname = "type-nat-solver";
  version = "0.1.0.0-2016-02-02";
  src = fetchgit {
    url = "https://github.com/yav/type-nat-solver.git";
    rev = "5589eb7be97e01bc0404faa0728f834166255b55";
    sha256 = "0fcxrbfvwm7sdc3d15lns3qpi1bs1khq1dv5m34l6v3205f6a101";
  };
  libraryHaskellDepends = [
    base containers ghc ghc-tcplugins-extra simple-smt
  ];
  librarySystemDepends = [ z3-exe ];
  testHaskellDepends = [ base ];
  doHaddock = false;   # Haddock syntax error, and docs are useless anyway
  license = stdenv.lib.licenses.bsd3;
  patchPhase = ''
    mkdir -p $out

    substituteInPlace src/TypeNatSolver.hs \
      --replace 'exe = "z3"' 'exe = "${z3-exe}/bin/z3"'

    substituteInPlace type-nat-solver.cabal \
      --replace 'main-is: A.hs' 'main-is: Test.hs'

    cp ${./Test.hs} examples/Test.hs
  '';
}
