{ commands, ... }:
let inherit (commands) keepassxc;
in
{
  home.packages = [ keepassxc.pkg ];

  systemd.user.services = {
    keepassxc = {
      Unit = {
        Description = "Password manager";
        After = [ "graphical-session-pre.target" "tray.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = keepassxc.getExe "keepassxc";
        Restart = "on-failure";
      };
    };
  };
}
