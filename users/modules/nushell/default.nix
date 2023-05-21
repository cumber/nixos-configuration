{ config, ... }:
{
  # Have alacritty start nushell instead of default shell in /etc/passwd
  programs.alacritty.settings.shell =
    "${config.programs.nushell.package}/bin/nu";

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;

    environmentVariables = {
      # Git commit messages open in nano otherwise.
      # Can't just use ee wrapper, as --no-wait causes emacsclient to
      # return before message is saved, so git doesn't see it.
      VISUAL = "'emacsclient --alternate-editor \"\" --create-frame'";
    };

    extraConfig = ''
      extern nd [...rest] {
        nix develop --impure $rest -c nu
      }

      extern "nd up" [...rest] {
        nix develop --impure $rest -c devenv up
      }
    '';

    shellAliases = {
      # tree won't colourise by default if LS_COLORS isn't set
      tree = "tree -C";

      # TODO; nushell version of ns and nix-dev?
    };
  };
}
