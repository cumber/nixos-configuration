self: super: {
  signal-desktop = self.stdenv.mkDerivation (
    let sd = super.signal-desktop;
     in {
          name = sd.name;
          version = sd.version;
          meta = sd.meta;

          nativeBuildInputs = [ self.binutils ];
          phases = [ "installPhase" ];
          installPhase = ''
            cp -r ${sd} $out

            # Replace symlink in bin; absolute path to overridden package
            chmod u+w $out/bin
            rm $out/bin/.signal-desktop-wrapped
            ln -s $out/lib/Signal/signal-desktop $out/bin/.signal-desktop-wrapped

            # Patch to include appindicator
            chmod u+w $out/lib/Signal/signal-desktop
            runpath="$(readelf -d $out/lib/Signal/signal-desktop | grep RUNPATH | sed -e 's/^.*\[\(.*\)]$/\1/' | sed -e "s|${sd}|$out|"):${self.libappindicator-gtk3}/lib"
            patchelf --set-rpath $runpath $out/lib/Signal/signal-desktop

            # Fix previous wrapper script; absolute path to overridden package
            substituteInPlace $out/bin/signal-desktop \
              --replace ${sd} $out

            # Fix path in desktop link
            substituteInPlace $out/share/applications/signal-desktop.desktop \
              --replace ${sd} $out
          '';
        }
  );
}
