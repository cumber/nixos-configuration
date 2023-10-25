{ pkgs, ... }:
let pname = "tutanota-desktop";
    version = "3.118.13";
    tutanota = pkgs.tutanota-desktop.overrideAttrs (old: {
      src = pkgs.fetchurl {
        url = "https://github.com/tutao/tutanota/releases/download/tutanota-desktop-release-${version}/${pname}-${version}-unpacked-linux.tar.gz";
        name = "tutanota-desktop-${version}.tar.gz";
        hash = "sha256-3kpfF/XG7w6qUooS5UsntMKnggG1LhmV9f+R35kkmb0=";
      };
    });
in
{
  home.packages = [ tutanota ];
}
