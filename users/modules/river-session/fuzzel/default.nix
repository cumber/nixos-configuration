{ pkgs, ... }:
let
  inherit (pkgs) foot;
in
{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        terminal = "${foot}/bin/foot";

        font = "Overpass:size=15";

        show-actions = true;
      };
    };
  };
}
