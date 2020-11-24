self: super: {
  zsh-haskell = super.stdenv.mkDerivation rec {
    pname = "zsh-haskell";
    version = "2020.02.16";

    src = super.fetchFromGitHub {
      owner = "coot";
      repo = "zsh-haskell";
      rev = "1a20600d2412baf8320e9cc9f6e41bd12b4cf371";
      sha256 = "0m3m0ljxzclb5kzjmb39g51rjbd1zyysfivd7y5hpnlir2460rzw";
    };

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };
}
