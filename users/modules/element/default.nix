{ commands, ... }:
let
  inherit (commands) element-desktop;
in
{
  home.packages = [ element-desktop.pkg ];

  systemd.user.services = {
    element = {
      Unit = {
        Description = "Element messaging service";
        After = [ "tray.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${element-desktop} --hidden";
        Restart = "on-failure";
      };
    };
  };
}
