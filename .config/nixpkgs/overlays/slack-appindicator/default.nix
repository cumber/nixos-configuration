self: super: {
  slack = self.stdenv.mkDerivation (
    let sl = super.slack;
     in {
          name = sl.name;
          meta = sl.meta;

          nativeBuildInputs = [ self.binutils self.file ];
          phases = [ "installPhase" ];
          installPhase = ''
            cp -r ${sl} $out

            # Patch to include appindicator
            for file in $(find $out -type f -exec file '{}' ';' | grep ELF | sed 's/^\(.*\):.*$/\1/'); do
              runpath="$(readelf -d $file | grep RUNPATH | sed -e 's/^.*\[\(.*\)]$/\1/' | sed -e "s|${sl}|$out|"):${self.libappindicator-gtk3}/lib"
              chmod u+w $file
              patchelf --set-rpath $runpath $file
            done

            # Fix previous wrapper script; absolute path to overridden package
            substituteInPlace $out/bin/slack \
              --replace ${sl} $out

            # Fix path in desktop link
            substituteInPlace $out/share/applications/slack.desktop \
              --replace ${sl} $out
          '';
        }
  );
}
