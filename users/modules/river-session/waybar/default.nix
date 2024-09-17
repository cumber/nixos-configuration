{
  lib,
  pkgs,
  commands,
  ...
}:
let
  inherit (commands) firefox resources;
  inherit (pkgs) material-design-icons overpass;

  tags = import ../river/tags.nix lib;

  gauge-widget = icon: on-click: {
    interval = 5;
    inherit on-click;
    states = {
      low = 20;
      medium = 50;
      high = 90;
    };
    format = "${icon}󰡳";
    format-low = "${icon}󰡵";
    format-medium = "${icon}󰊚";
    format-high = "${icon}󰡴";
  };
in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "tray.target";
    };
    style = ./waybar.css;

    settings = [
      {
        modules-left = [
          "river/tags"
          "river/layout"
        ];
        modules-center = [
          "river/window"
          "privacy"
        ];
        modules-right = [
          "idle_inhibitor"
          "cpu"
          "memory"
          "disk"
          "battery"
          "clock"
          "tray"
        ];

        "river/tags" = rec {
          tag-labels = [ "SP" ] ++ tags.all-labels;
          num-tags = builtins.length tag-labels;
        };

        "river/window" = {
          max-length = 100;
        };

        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󱰇";
            deactivated = "󰈉";
          };
          tooltip-format-activated = "Idle detection suppressed";
          tooltip-format-deactivated = "Idle detection normal";
        };

        cpu = gauge-widget "󰍛" "${resources} -t cpu";

        memory = gauge-widget "󰒋" "${resources} -t memory"// {
          tooltip-format = ''
            RAM: {used:0.1f} GiB of {total:0.1f} GiB
            Swap: {swapUsed:0.1f} GiB of {swapTotal:0.1f} GiB'';
        };

        disk = lib.recursiveUpdate (gauge-widget "󰆼" resources) (rec {
          states.medium = 80; # disk space is cheap; no highlight needed at 50%
          tooltip-format = ''
            Free: {percentage_free}% — {specific_free:0.1f} ${unit}
            Used: {specific_used:0.1f} ${unit} of {specific_total:0.1f} ${unit}'';
          unit = "GB";
        });

        clock = {
          format = "{:%I:%M %p}";
          locale = "en_AU.UTF-8";
          tooltip-format = "<tt><small>{calendar}</small></tt>";

          calendar = {
            mode = "month";
            mode-mon-col = 3;
            on-scroll = -1;
            format = {
              months = "<span color='#b4ffff'><b>{}</b></span>";
              days = "<b>{}</b>";
              weeks = "<span color='#80ff80'><b>W{}</b></span>";
              weekdays = "<span color='#80ff80'><b>{}</b></span>";
              today = "<span color='#69cfff'><b><u>{}</u></b></span>";
            };
          };

          on-click = "${firefox} --new-window 'https://calendar.google.com'";

          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        tray = {
          icon-size = 32;
        };
      }
    ];
  };

  home.packages = [
    material-design-icons
    overpass
  ];
}
