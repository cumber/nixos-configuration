{ mkDerivation, base, compton, fetchgit, networkmanagerapplet
, notify-osd, powerline, setxkbmap, signal-desktop, slack, stdenv
, synapse, syncthing-gtk, system-config-printer, taffybar, udiskie
, unix, X11, xmonad, xmonad-contrib
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
  license = stdenv.lib.licenses.bsd3;
  executableSystemDepends = [
    compton
    networkmanagerapplet
    notify-osd
    powerline
    setxkbmap
    signal-desktop
    slack
    synapse
    syncthing-gtk
    system-config-printer
    udiskie
  ];
  patchPhase = ''
    substituteInPlace src/Main.hs \
      --replace '@compton@' '${compton}' \
      --replace '@networkmanagerapplet@' '${networkmanagerapplet}' \
      --replace '@notify-osd@' '${notify-osd}' \
      --replace '@powerline@' '${powerline}' \
      --replace '@setxkbmap@' '${setxkbmap}' \
      --replace '@signal-desktop@' '${signal-desktop}' \
      --replace '@slack@' '${slack}' \
      --replace '@synapse@' '${synapse}' \
      --replace '@syncthing-gtk@' '${syncthing-gtk}' \
      --replace '@system-config-printer@' '${system-config-printer}' \
      --replace '@udiskie@' '${udiskie}' \
  '';
}
