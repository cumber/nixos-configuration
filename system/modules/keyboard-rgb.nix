{ pkgs, ... }:
{
  # Enable the OpenRGB server
  services.hardware.openrgb.enable = true;

  # Run a one-shot service to apply basic RGB settings at boot
  systemd.services.openrgb-init-rgb = {
    description = "Initialise OpenRGB settings on startup";

    wantedBy = [ "multi-user.target" ];
    requires = [ "openrgb.service" ];
    after = [ "openrgb.service" ];

    serviceConfig = {
      Type = "oneshot";
      DynamicUsers = "yes";
      ExecStart = "${pkgs.openrgb}/bin/openrgb --mode Static --color ffffff --brightness 4";
    };
  };
}
