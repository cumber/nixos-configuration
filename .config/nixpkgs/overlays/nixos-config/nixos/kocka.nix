{ config, pkgs, ... }:
  {
    networking.hostName = "kocka";

    # Use the systemd-boot efi boot loader.
    imports = [ ./systemd-boot.nix ];

    # Need to allow for nix-serve to work
    networking.firewall.allowedTCPPorts = [ 5000 ];

    services = {
      sshd.enable = true;

      nix-serve = {
        enable = true;
        secretKeyFile = "/etc/nixos/secrets/nix-serve.sec";
      };

      xserver.xrandrHeads = [ "DP-2" "DP-1" ];
    };
  }
