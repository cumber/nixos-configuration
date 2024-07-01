{ ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = false;

      "import" = [ ./paper-theme.toml ];

      font = {
        normal = {
          family = "Source Code Pro";
        };
        size = 13;
      };

      keyboard.bindings = [
        {
          mods = "Control|Shift";
          key = "N";
          action = "SpawnNewInstance";
        }
      ];

      # This basically corresponds to the default hints shown at
      # https://alacritty.org/config-alacritty.html, except that I
      # require Control to be held to click links. Unfortunately I
      # don't seem to be able to change that setting without
      # reimplementing the whole default hint configuration.
      hints.enabled = [{
        command = "xdg-open";
        hyperlinks = true;
        binding = {
          mods = "Control|Shift";
          key = "U";
        };
        mouse = {
          enabled = true;
          mods = "Control";
        };
        post_processing = true;
        persist = false;

        # Careful; getting the right backslashes to make this through
        # nix and then toml is not a precise copy from alacritty's docs
        regex = ''(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>"\\s{-}\\^⟨⟩`]+'';
      }];
    };
  };
}
