{ commands, ... }:
let
  inherit (commands) foot;
in
{
  programs.fuzzel = {
    enable = true;

    settings = {
      main = {
        terminal = foot.exe;

        font = "Overpass:size=15";

        show-actions = true;
      };
    };
  };
}
