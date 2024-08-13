{ commands, ... }:
let
  inherit (commands) tutanota-desktop;
in
{
  home.packages = [ tutanota-desktop.pkg ];

  systemd.user.services = {
    tutanota = {
      Unit = {
        Description = "Tuta email client";
        After = [
          "graphical-session-pre.target"
          "tray.target"
        ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        # -a arg makes it start minimized
        ExecStart = "${tutanota-desktop} -a";
        Restart = "on-failure";
      };
    };
  };
}
