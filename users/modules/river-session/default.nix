{ pkgs, ... }:
let
  inherit (pkgs)
    lswt
    waylock
    wl-clipboard
    wlr-randr
    ;
in
{
  imports = [
    ./river
    ./fuzzel
    ./waybar
    ./wired-notify
  ];

  home.packages = [
    lswt
    waylock # NOTE: needs system-level PAM config to be able to unlock!
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
