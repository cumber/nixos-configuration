{ pkgs, ... }:
let inherit (pkgs)
      dmenu
      firefox
    ;
in
{
  services.dunst = {
    enable = true;

    iconTheme = {
      name = "Numix";
      package = pkgs.numix-icon-theme;
      size = "48";
    };

    settings = {
      global = {
        # notification behaviour
        idle_threshold = "30s";
        follow = "mouse";
        mouse_right_click = "context";
        notification_limit = 6;

        # keyboard bindings
        close = "ctrl+space";
        close_all = "ctrl+shift+space";
        context = "ctrl+shift+period";
        history = "ctrl+grave";

        # appearance
        corner_radius = 10;
        font = "Source Sans Pro 11";
        separator_height = 30;
        width = "500 800";

        # programs
        browser = "${firefox}/bin/firefox -new-tab";
        dmenu = "${dmenu}/bin/dmenu -p dunst -fn 'Source Sans Pro-20'";
      };
    };
  };
}
