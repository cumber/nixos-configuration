{ lib, ... }:
{
  # Terminal directory browser; alternative to tree
  programs.broot = {
    enable = true;

    settings = {
      default_flags = "--show-git-info --sort-by-type-dirs-first";

      enable_kitty_keyboard = lib.mkForce true;

      terminal_title = "{file}";

      special_paths = lib.mkForce {
        "/var/run/media" = {
          list = "never";
          sum = "never";
        };
      };
    };
  };
}
