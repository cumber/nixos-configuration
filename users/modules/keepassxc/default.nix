{ pkgs, ... }:
let inherit (pkgs) keepassxc;
in
{
  home.packages = [ keepassxc ];

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
        ExecStart = ''${keepassxc}/bin/keepassxc'';
        Restart = "on-failure";
      };
    };
  };
}
