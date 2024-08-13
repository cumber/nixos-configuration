{ commands, ... }:
let
  inherit (commands) signal-desktop;
in
{
  home.packages = [ signal-desktop.pkg ];

  systemd.user.services = {
    signal = {
      Unit = {
        Description = "Signal messaging service";
        After = [ "tray.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${signal-desktop} --start-in-tray";
        Restart = "on-failure";
      };
    };
  };
}
