{ pkgs, ... }:
let pname = "tutanota-desktop";
    version = "3.118.25";
    tutanota = pkgs.tutanota-desktop.overrideAttrs (old: {
      src = pkgs.fetchurl {
        url = "https://github.com/tutao/tutanota/releases/download/tutanota-desktop-release-${version}/${pname}-${version}-unpacked-linux.tar.gz";
        name = "tutanota-desktop-${version}.tar.gz";
        hash = "sha256-iEb56vhL/gWrM8QPfkV8pD2D+BYv6Eb9MDisWfm2+L4=";
      };
    });
in
{
  home.packages = [ tutanota ];
}
