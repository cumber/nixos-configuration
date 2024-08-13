{
  lib,
  options,
  commands,
  ...
}:
let
  inherit (commands)
    foot
    fuzzel
    jq
    systemd
    wlogout
    wlr-randr
    ;

  tags = import ./tags.nix lib;
in
{
  wayland.windowManager.river = {
    enable = true;

    # Rely on river installed as a system package, since the session needs to be
    # set up system-wide, but still *configure* river per-user
    package = null;

    settings = {
      map = {
        normal =
          {
            # see terminal module for configuration of foot
            "Super+Shift Return" = "spawn ${foot}";

            "Super Z" = "spawn ${wlogout}";
            "Super X" = "spawn ${fuzzel}";
            "Super+Shift Z" = "spawn '${systemd.getExe "loginctl"} lock-session'";
            "Super+Shift C" = "close";

            "Super Up" = "focus-view up";
            "Super Down" = "focus-view down";
            "Super left" = "focus-view left";
            "Super Right" = "focus-view right";
            "Super Tab" = "focus-view next";
            "Super Backspace" = "focus-view previous";

            "Super+Shift Up" = "swap up";
            "Super+Shift Down" = "swap down";
            "Super+Shift Left" = "swap left";
            "Super+Shift Right" = "swap right";
            "Super+Shift Tab" = "swap next";
            "Super+Shift Backspace" = "swap previous";

            "Super+Control Up" = "focus-output up";
            "Super+Control Down" = "focus-output down";
            "Super+Control left" = "focus-output left";
            "Super+Control Right" = "focus-output right";
            "Super+Control Tab" = "focus-output next";
            "Super+Control Backspace" = "focus-output previous";

            "Super+Control+Shift Up" = "send-to-output up";
            "Super+Control+Shift Down" = "send-to-output down";
            "Super+Control+Shift left" = "send-to-output left";
            "Super+Control+Shift Right" = "send-to-output right";
            "Super+Control+Shift Tab" = "send-to-output next";
            "Super+Control+Shift Backspace" = "send-to-output previous";

            "Super Space" = "toggle-fullscreen";
          }
          // lib.mergeAttrsList (
            lib.forEach tags.all-labels (
              label:
              let
                l = toString label;
                m = toString (tags.mask-for-label label);
              in
              {
                # Set/toggle a single tag label on output/view
                "Super ${l}" = "set-focused-tags ${m}";
                "Super+Control ${l}" = "toggle-focused-tags ${m}";
                "Super+Shift ${l}" = "set-view-tags ${m}";
                "Super+Shift+Control ${l}" = "toggle-view-tags ${m}";
              }
            )
          )
          // (
            let
              all-tags-mask = toString (tags.mask-for-labels tags.all-labels);
            in
            {
              # Set all standard tag labels on output/view
              "Super 0" = "set-focused-tags ${all-tags-mask}";
              "Super+Shift 0" = "set-view-tags ${all-tags-mask}";

              # We use a non-keyboard addressable tag label as a "scratchpad"; we can
              # easily send views to that tag and toggle the scratchpad on or
              # off on each monitor regardless of what other tags it is showing.
              "Super P" = "toggle-focused-tags ${toString tags.mask-for-scratchpad}";
              "Super+Shift P" = "set-view-tags ${toString tags.mask-for-scratchpad}";

              # TODO: implement sticky windows as well?
            }
          );
      };

      map-pointer = {
        normal = {
          "Super BTN_LEFT" = "move-view";
          "Super BTN_MIDDLE" = "toggle-float";
          "Super BTN_RIGHT" = "resize-view";
        };
      };

      # Mouse focus, and move mouse to window when focussed by keyboard
      focus-follows-cursor = "normal";
      set-cursor-warp = "on-focus-change";

      border-width = "3";
      border-color-focused = "0x00cc00";
      border-color-unfocused = "0x666666";
      border-color-urgent = "0xee0000";

      # This is installed in gtk-config module
      xcursor-theme = "graphite-light";

      keyboard-layout = "-options compose:ralt au";

      default-layout = "rivertile";

      spawn = [ "'rivertile -view-padding 6 -outer-padding 6'" ];
    };

    systemd.variables =
      let
        default = options.wayland.windowManager.river.systemd.variables.default;
      in
      default ++ [ "XDG_SESSION_TYPE" ];

    extraConfig = ''
      # Set all outputs to focus tag label 1
      for output in $(${wlr-randr} --json | ${jq} --raw-output .[].name); do
        riverctl focus-output "$output"
        riverctl set-focused-tags "${toString (tags.mask-for-label 1)}"
      done

      # Set portait monitor to top layout, then focus back to main monitor
      # TODO: configure this per machine so config works on sima too
      riverctl focus-output "DP-3"
      riverctl send-layout-cmd rivertile "main-location top"
      riverctl focus-output "DP-2"
    '';
  };
}
