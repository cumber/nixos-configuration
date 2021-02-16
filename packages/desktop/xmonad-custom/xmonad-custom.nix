{ mkDerivation, base, gdk_pixbuf, gtk3, lib, lightlocker
, pulseaudioLight, taffybar, unix, wrapGAppsHook, X11, xmonad
, xmonad-contrib
}:
mkDerivation {
  pname = "xmonad-custom";
  version = "0.0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base taffybar unix X11 xmonad xmonad-contrib
  ];
  description = "My XMonad build";
  license = lib.licenses.bsd3;
  executableSystemDepends = [
    wrapGAppsHook
    gtk3
    gdk_pixbuf
  ];
  postPatch = ''
    substituteInPlace src/Taffybar.hs \
      --replace '{{out}}' "$out" \
      --replace '{{lightlocker}}' '${lightlocker}' \
      --replace '{{pulseaudioLight}}' '${pulseaudioLight}' \
    ;
    substituteInPlace src/Xmonad.hs \
      --replace '{{out}}' "$out" \
      --replace '{{lightlocker}}' '${lightlocker}' \
      --replace '{{pulseaudioLight}}' '${pulseaudioLight}' \
    ;
  '';
}
