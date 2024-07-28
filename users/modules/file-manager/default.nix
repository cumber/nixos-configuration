{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pcmanfm
    file-roller
  ];
}
