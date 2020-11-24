{ stdenv, unzip, fetchurl, makeWrapper, jre }:
  stdenv.mkDerivation rec {
    name = "chatty-${version}";
    version = "0.8.7";

    src = fetchurl {
      url =  "https://github.com/chatty/chatty/releases/download/v${version}/Chatty_${version}.zip";
      sha256 = "1yr67nbmp4zd2acckyay8ya55wn5i5ap3jgjcrvi7h07dby5j1vw";
    };

    buildInputs = [ makeWrapper unzip ];
    unpackPhase = "true";

    installPhase = ''
      mkdir -p $out/lib
      unzip $src -d $out/lib

      mkdir -p $out/bin
      makeWrapper ${jre}/bin/java $out/bin/chatty \
        --add-flags "-jar $out/lib/Chatty.jar"
    '';
  }
