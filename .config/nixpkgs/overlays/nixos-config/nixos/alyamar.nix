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

    nix = {
      binaryCaches = [
        "http://kocka.goldie:5000"
        "https://cache.nixos.org/"
      ];
      binaryCachePublicKeys = [
        "kocka:/M85ADJvkdibcMJtP+3uj4e3HCn/LkIAoy8r5V3QTNY="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };


    services = {
      sshd.enable = true;

      nix-serve = {
        enable = true;
        secretKeyFile = "/etc/nixos/secrets/nix-serve.sec";
      };

      xserver.xrandrHeads = [ "DisplayPort-0" "DisplayPort-1" ];
    };
  }
