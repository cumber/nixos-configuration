{ pkgs, config, ... }:
{
  # Have alacritty start nushell instead of default shell in /etc/passwd
  programs.alacritty.settings.shell =
    "${config.programs.nushell.package}/bin/nu";

  # Make carapace available for completions
  home.packages = [ pkgs.carapace ];

  programs.nushell = {
    enable = true;

    configFile.text = ''
      source ${./default-config.nu}
      source ${./config.nu}
      source ${./commands.nu}
    '';

    envFile.text = ''
      source ${./default-env.nu}
      source ${./environment.nu}
      source ${./ls-colors.nu}
    '';
  };
}
