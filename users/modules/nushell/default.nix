{ config, ... }:
{
  # Have alacritty start nushell instead of default shell in /etc/passwd
  programs.alacritty.settings.shell =
    "${config.programs.nushell.package}/bin/nu";

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };
}
