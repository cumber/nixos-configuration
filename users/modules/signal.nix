{ pkgs, ... }:
{
  home.packages = [ pkgs.signal-desktop ];

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
        ExecStart = ''${pkgs.signal-desktop}/bin/signal-desktop --start-in-tray'';
        Restart = "on-failure";
      };
    };
  };
}
