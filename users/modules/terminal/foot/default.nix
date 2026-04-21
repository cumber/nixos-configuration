{ osConfig, ... }:
let
  host = osConfig.networking.hostName;
in
{
  programs.foot = {
    enable = true;

    settings = {
      main = {
        shell = "nu";

        dpi-aware = "yes";
        pad = "0x0 center";

        font = (
          let size = if host == "sima" then 8 else 14;
          in "Source Code Pro:size=${toString size}"
        );

        initial-color-theme = "light";
      };

      colors-light = {
        background = "faf6fa";
        foreground = "000000";

        regular0 = "000000"; # black
        regular1 = "ca402b"; # red
        regular2 = "379a37"; # green
        regular3 = "bb8a35"; # yellow
        regular4 = "516aec"; # blue
        regular5 = "7b59c0"; # magenta
        regular6 = "159393"; # cyan
        regular7 = "e1d2f1"; # white
        bright0 = "776977"; # bright black
        bright1 = "ca402b"; # bright red
        bright2 = "379a37"; # bright green
        bright3 = "bb8a35"; # bright yellow
        bright4 = "516aec"; # bright blue
        bright5 = "7b59c0"; # bright magenta
        bright6 = "159393"; # bright cyan
        bright7 = "faf6fa"; # bright white
      };
    };
  };
}
