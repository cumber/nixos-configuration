{ pkgs, config, ... }:
{
  # Have alacritty start nushell instead of default shell in /etc/passwd
  programs.alacritty.settings.shell =
    "${config.programs.nushell.package}/bin/nu";

  # Make carapace available for completions
  home.packages = [ pkgs.carapace ];

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
      # Starts nushell inside `nix develop --impure`
      extern nd [
        ...rest # All arguments will be passed to nix develop
      ] {
        nix develop --impure $rest -c nu
      }

      # Runs `devenv up` inside `nix develop --impure`
      extern "nd up" [
        ...rest # All arguments will be passed to nix develop
      ] {
        nix develop --impure $rest -c devenv up
      }

      # Runs `nix repl` preloaded with the <repl> path; my system
      # config defines this with a helpful set of variables (all of
      # nixpkgs, builtins and lib more easily available, etc).
      extern nr [
        ...rest # All arguments will be passed to nix repl
      ] {
        nix repl --file <repl> $rest
      }
    '';

    shellAliases = {
      # tree won't colourise by default if LS_COLORS isn't set
      tree = "tree -C";

      # TODO; nushell version of ns and nix-dev?
    };
  };
}
