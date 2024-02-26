{ pkgs, ... }:
let tuta = pkgs.tutanota-desktop;
in
{
  home.packages = [ tuta ];

  systemd.user.services = {
    tutanota = {
      Unit = {
        Description = "Tuta email client";
        After = [ "graphical-session-pre.target" "tray.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };

      Service = {
        # -a arg makes it start minimized
        ExecStart = ''${tuta}/bin/tutanota-desktop -a'';
        Restart = "on-failure";
      };
    };
  };
}
