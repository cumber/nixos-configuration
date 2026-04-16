{ pkgs, ... }:
{
  home.packages = [ pkgs.elvish ];

  home.file = {
    ".config/elvish/rc.elv".source = ./rc.elv;
  };
}
