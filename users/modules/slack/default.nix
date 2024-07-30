{ pkgs, ... }:
{
  home.packages = [ pkgs.slack ];

  systemd.user.services = {
    slack = {
      Unit = {
        Description = "Slack messaging service";
        After = [ "graphical-session-pre.target" "tray.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        # --startup arg makes it start minimized
        # --disable-gpu-compositing seems to help flickering on wayland
        ExecStart = ''${pkgs.slack}/bin/slack --startup --disable-gpu-compositing'';
        Restart = "on-failure";
      };
    };
  };
}
