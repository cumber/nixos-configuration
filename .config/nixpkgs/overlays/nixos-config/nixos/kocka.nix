{ config, pkgs, ... }:
  {
    networking.hostName = "kocka";

    # Use the systemd-boot efi boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Need to allow for nix-serve to work
    networking.firewall.allowedTCPPorts = [ 5000 ];

    services = {
      sshd.enable = true;

      nix-serve = {
        enable = true;
        secretKeyFile = "/etc/nixos/secrets/nix-serve.sec";
      };

      xserver.xrandrHeads = [ "DisplayPort-0" "DisplayPort-1" ];
    };
  }
