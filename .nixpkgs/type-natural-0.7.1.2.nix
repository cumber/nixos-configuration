{ mkDerivation, base, constraints, equational-reasoning
, ghc-typelits-natnormalise, ghc-typelits-presburger, monomorphic
, singletons, stdenv, template-haskell
}:
mkDerivation {
  pname = "type-natural";
  version = "0.7.1.2";
  sha256 = "1rl223zgas6q41ml2rnyy875cilraib5678xcihrw5qn0rkc4y62";
  libraryHaskellDepends = [
    base constraints equational-reasoning ghc-typelits-natnormalise
    ghc-typelits-presburger monomorphic singletons template-haskell
  ];
  homepage = "https://github.com/konn/type-natural";
  description = "Type-level natural and proofs of their properties";
  license = stdenv.lib.licenses.bsd3;
}
