{ ... }:
{
  programs = {
    starship.enable = true;
    starship.settings = {
      format = "$all$shlvl$character";
      
      aws.disabled = true;

      directory = {
        truncation_length = 5;
        truncation_symbol = "…/";
      };

      nix_shell = {
        heuristic = true;
      };

      shell = {
        disabled = false;
        format = "[$indicator]($style)";
        style = "blue bold";
      };

      shlvl = {
        disabled = false;
        format = "[$symbol]($style)";
        symbol = "❯";
        repeat = true;
        repeat_offset = 1;
      };
    };
  };
}
