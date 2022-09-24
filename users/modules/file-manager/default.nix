{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pcmanfm
    gnome.file-roller
  ];
}
