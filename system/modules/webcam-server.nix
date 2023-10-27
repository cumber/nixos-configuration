{ config, pkgs, ... }:
{
  # RTMP protocol for streaming server
  networking.firewall.allowedTCPPorts = [ 1935 ];

  users = {
    groups.webcam-server = {};

    users.webcam-server = {
      isSystemUser = true;
      description = "User for the webcam-server program";
      group = "webcam-server";
      extraGroups = [ "video" ];
    };
  };

  security.sudo.extraRules = [
    {
      groups = [ "users" ];
      runAs = "webcam-server";
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];
}
