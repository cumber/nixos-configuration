{ mkDerivation, base, gdk-pixbuf, gtk3, lib, lightlocker
, pulseaudio, taffybar, unix, wrapGAppsHook, X11, xmonad
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
    gdk-pixbuf
  ];
  postPatch = ''
    substituteInPlace src/Taffybar.hs \
      --replace '{{out}}' "$out" \
      --replace '{{lightlocker}}' '${lightlocker}' \
      --replace '{{pulseaudio}}' '${pulseaudio}' \
    ;
    substituteInPlace src/Xmonad.hs \
      --replace '{{out}}' "$out" \
      --replace '{{lightlocker}}' '${lightlocker}' \
      --replace '{{pulseaudio}}' '${pulseaudio}' \
    ;
  '';
}
