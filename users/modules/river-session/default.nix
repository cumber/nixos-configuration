{ pkgs, ... }:
let
  inherit (pkgs)
    lswt
    wl-clipboard
    wlr-randr
    ;
in
{
  imports = [
    ./river
    ./fuzzel
    ./udiskie
    ./waybar
    ./waylock
    ./wired-notify
  ];

  home.packages = [
    lswt
    wl-clipboard
    wlr-randr
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common = {
      default = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
      "org.freedesktop.impl.portal.Screenshot" = "wlr";
    };
  };
}
