{ ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = false;

      "import" = [ ./paper-theme.yaml ];

      font = {
        normal = {
          family = "Source Code Pro";
        };
        size = 13;
      };
    };
  };
}
