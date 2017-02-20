{ mkDerivation, base, compton, fetchgit, gnome_keyring
, networkmanagerapplet, powerline, process, setxkbmap, stdenv
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
    base process taffybar unix X11 xmonad xmonad-contrib
  ];
  description = "My XMonad build";
  license = stdenv.lib.licenses.bsd3;
  executableSystemDepends = [
    compton
    gnome_keyring
    networkmanagerapplet
    powerline
    setxkbmap
    synapse
    syncthing-gtk
    system-config-printer
    udiskie
  ];
  patchPhase = ''
    substituteInPlace src/Main.hs \
      --replace '@compton@' '${compton}' \
      --replace '@gnome_keyring@' '${gnome_keyring}' \
      --replace '@networkmanagerapplet@' '${networkmanagerapplet}' \
      --replace '@powerline@' '${powerline}' \
      --replace '@setxkbmap@' '${setxkbmap}' \
      --replace '@synapse@' '${synapse}' \
      --replace '@syncthing-gtk@' '${syncthing-gtk}' \
      --replace '@system-config-printer@' '${system-config-printer}' \
      --replace '@udiskie@' '${udiskie}' \
  '';
}
