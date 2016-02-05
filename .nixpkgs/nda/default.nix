{ python27, stdenv }:

stdenv.mkDerivation {
  name = "nda";
  version = "0.1.0.0";
  src = ./nda.py;
  phases = [ "installPhase" "fixupPhase" "distPhase" ];
  buildInputs = [ python27 ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/$name
    chmod +x $out/bin/$name
  '';
}
