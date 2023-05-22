{ pkgs, ... }:
{
  home.packages = [ pkgs.element-desktop ];

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
        ExecStart = ''${pkgs.element-desktop}/bin/element-desktop --hidden'';
        Restart = "on-failure";
      };
    };
  };
}
