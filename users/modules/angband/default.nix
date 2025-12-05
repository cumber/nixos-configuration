{ pkgs, ... }:
let
  inherit (pkgs)
    angband
    symlinkJoin
    ;
  sdlAngband = angband.override { enableSdl2 = true; };

  # Angband 4.2.5 has a desktop file with a complex quoted Exec that fuzzel
  # doesn't work on; it's since been changed to a simple one, but there's
  # been no release since then. So just substitute a copy of the desktop file
  # from more recent code.
  angband' = symlinkJoin {
    inherit (sdlAngband)
      pname
      version
      passthru
      ;
    paths = [ sdlAngband ];

    postBuild = ''
      rm $out/share/applications/angband.desktop
      cp ${./angband.desktop} $out/share/applications/angband.desktop
    '';
  };
in
{
  home.packages = [ angband' ];
}
