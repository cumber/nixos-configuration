{ config, pkgs, ... }:
  {
    networking.hostName = "kocka";

    imports = [
      ../../modules/systemd-boot.nix
      ../../modules/pipewire.nix
      ../../modules/keyboard-rgb.nix
    ];

    # Need to allow for nix-serve to work
    networking.firewall.allowedTCPPorts = [ 5000 ];

    services = {
      fstrim.enable = true;

      sshd.enable = true;

      nix-serve = {
        enable = true;
        secretKeyFile = "/etc/nixos/secrets/nix-serve.sec";
      };

      # Use proprietary nvidia driver
      xserver = {
        videoDrivers = [ "nvidia" ];

        xrandrHeads = [
          {
            output = "DP-2";
            primary = true;
          }
          {
            output = "DP-4";
            monitorConfig = ''Option "Rotate" "left'';
          }
        ];
      };
    };

    virtualisation.docker.enable = true;

    # Set your time zone.
    time.timeZone = "Australia/Melbourne";
  }
