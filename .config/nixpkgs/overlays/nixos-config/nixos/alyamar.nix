{ config, pkgs, ... }:
  {
    networking.hostName = "alyamar";

    # Need to allow for nix-serve to work
    networking.firewall.allowedTCPPorts = [ 5000 ];

    # Use the GRUB 2 boot loader.
    boot.loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/sda";
      extraEntries = ''
        menuentry "Windows 10" {
          set root=(hd0,1)
          chainloader +1
        }
      '';
    };

    services = {
      sshd.enable = true;

      nix-serve = {
        enable = true;
        secretKeyFile = "/etc/nixos/nix-serve.sec";
      };

      xserver.xrandrHeads = [ "DisplayPort-0" "DisplayPort-1" ];
    };
  }
