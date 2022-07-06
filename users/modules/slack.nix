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
        # -u arg makes it start minimized
        ExecStart = ''${pkgs.slack}/bin/slack -u'';
        Restart = "on-failure";
      };
    };
  };
}
