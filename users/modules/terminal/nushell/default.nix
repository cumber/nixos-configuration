{ ... }:
{
  programs.nushell = {
    enable = true;

    configFile.text = ''
      source ${./config.nu}
      source ${./commands.nu}
    '';

    envFile.text = ''
      source ${./ls-colors.nu}
    '';

    environmentVariables = {
      # Let carapace fallback to bash completion scripts; lots of packages will
      # automatically install these in XDG_DATA_DIRS
      CARAPACE_BRIDGES = "'bash'";
    };
  };

  programs.carapace = {
    enable = true;
  };
}
