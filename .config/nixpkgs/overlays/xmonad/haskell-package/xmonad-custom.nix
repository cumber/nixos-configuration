{ mkDerivation, base, compton, directory, emacs-custom, filepath
, gdk_pixbuf, gtk3, keepassxc, lightlocker, networkmanagerapplet
, notify-osd, powerline, process, pulseaudioLight, setxkbmap
, signal-desktop, slack, status-notifier-item, stdenv, synapse
, syncthing-gtk, system-config-printer, taffybar, udiskie, unix
, wrapGAppsHook, X11, xmonad, xmonad-contrib
}:
mkDerivation {
  pname = "xmonad-custom";
  version = "0.0.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [
    base directory filepath process taffybar unix X11 xmonad
    xmonad-contrib
  ];
  description = "My XMonad build";
  license = stdenv.lib.licenses.bsd3;
  executableSystemDepends = [
    wrapGAppsHook
    gtk3
    gdk_pixbuf
  ];
  postPatch = ''
    substituteInPlace src/Taffybar.hs \
      --replace '{{out}}' "$out" \
      --replace '{{compton}}' '${compton}' \
      --replace '{{emacs-custom}}' '${emacs-custom}' \
      --replace '{{keepassxc}}' '${keepassxc}' \
      --replace '{{lightlocker}}' '${lightlocker}' \
      --replace '{{networkmanagerapplet}}' '${networkmanagerapplet}' \
      --replace '{{notify-osd}}' '${notify-osd}' \
      --replace '{{powerline}}' '${powerline}' \
      --replace '{{pulseaudioLight}}' '${pulseaudioLight}' \
      --replace '{{setxkbmap}}' '${setxkbmap}' \
      --replace '{{signal-desktop}}' '${signal-desktop}' \
      --replace '{{slack}}' '${slack}' \
      --replace '{{status-notifier-item}}' '${status-notifier-item}' \
      --replace '{{synapse}}' '${synapse}' \
      --replace '{{syncthing-gtk}}' '${syncthing-gtk}' \
      --replace '{{system-config-printer}}' '${system-config-printer}' \
      --replace '{{udiskie}}' '${udiskie}' \
    ;
    substituteInPlace src/Xmonad.hs \
      --replace '{{out}}' "$out" \
      --replace '{{compton}}' '${compton}' \
      --replace '{{emacs-custom}}' '${emacs-custom}' \
      --replace '{{keepassxc}}' '${keepassxc}' \
      --replace '{{lightlocker}}' '${lightlocker}' \
      --replace '{{networkmanagerapplet}}' '${networkmanagerapplet}' \
      --replace '{{notify-osd}}' '${notify-osd}' \
      --replace '{{powerline}}' '${powerline}' \
      --replace '{{pulseaudioLight}}' '${pulseaudioLight}' \
      --replace '{{setxkbmap}}' '${setxkbmap}' \
      --replace '{{signal-desktop}}' '${signal-desktop}' \
      --replace '{{slack}}' '${slack}' \
      --replace '{{status-notifier-item}}' '${status-notifier-item}' \
      --replace '{{synapse}}' '${synapse}' \
      --replace '{{syncthing-gtk}}' '${syncthing-gtk}' \
      --replace '{{system-config-printer}}' '${system-config-printer}' \
      --replace '{{udiskie}}' '${udiskie}' \
    ;
  '';
}
