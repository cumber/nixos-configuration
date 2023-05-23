{ ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = false;

      font = {
        normal = {
          family = "Source Code Pro";
        };
        size = 13;
      };

      colors = {
        primary = {
          foreground = "#64526F";
          background = "#FAF7EE";
        };

        cursor = {
          cursor =     "#64526F";
          text =       "#FAF7EE";
        };
        normal = {
          black =      "#FAF7EE";
          red =        "#DF201C";
          green =      "#29A0AD";
          yellow =     "#DB742E";
          blue =       "#3980C2";
          magenta =    "#2C9473";
          cyan =       "#6B3062";
          white =      "#64526F";
        };

        bright = {
          black =      "#9F93A1";
          red =        "#DF201C";
          green =      "#29A0AD";
          yellow =     "#DB742E";
          blue =       "#3980C2";
          magenta =    "#2C9473";
          cyan =       "#6B3062";
          white =      "#64526F";
        };
      };
    };
  };
}
