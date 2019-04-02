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

            # Patch to include appindicator
            chmod u+w $out/libexec/.signal-desktop-wrapped
            runpath="$(readelf -d $out/libexec/.signal-desktop-wrapped | grep RUNPATH | sed -e 's/^.*\[\(.*\)]$/\1/' | sed -e "s|${sd}|$out|"):${self.libappindicator-gtk3}/lib"
            patchelf --set-rpath $runpath $out/libexec/.signal-desktop-wrapped

            # Fix previous wrapper script; absolute path to overridden package
            substituteInPlace $out/libexec/signal-desktop \
              --replace ${sd} $out

            # Replace symlink in bin; absolute path to overridden package
            chmod u+w $out/bin
            rm $out/bin/signal-desktop
            ln -s $out/libexec/signal-desktop $out/bin/signal-desktop

            # Fix path in desktop link
            substituteInPlace $out/share/applications/signal-desktop.desktop \
              --replace ${sd} $out
          '';
        }
  );
}
