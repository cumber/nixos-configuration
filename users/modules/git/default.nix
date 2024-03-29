{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    aliases = {
      tree = "log --graph --decorate --oneline -n 40";
    };

    # syntax highlighter
    delta.enable = true;
    delta.options = {
      light = true;
    };

    extraConfig = {
      core = {
        autocrlf = "input";
        safecrlf = "warn";
      };

      diff = {
        algorithm = "histogram";
        mnemonicprefix = true;
        renames = "copies";
      };

      push.default = "upstream";
      pull.rebase = true;
    };

    ignores = [
      # vim swap files
      ".*.swp"
      ".swp"

      # emacs autosave and lock files
      # don't forget to double-backslash-escape the hash symbols
      "\\#*\\#"
      ".\\#*"

      # common backup filename: ends in ~
      "*~"

      # openoffice lock files
      ".~lock*#"

      # python byte compiled files
      "*.pyc"

      # leksah state files
      "*.lkshw"
      "*.lkshs"

      # tags files
      "TAGS"

      # stack work directories
      ".stack-work/"
    ];
  };
}
