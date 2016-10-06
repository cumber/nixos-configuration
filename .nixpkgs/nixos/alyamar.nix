{ config, pkgs, ... }:
  {
    networking.hostName = "alyamar";

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

    services.xserver.xrandrHeads = [ "DisplayPort-0" "DisplayPort-1" ];
  }
