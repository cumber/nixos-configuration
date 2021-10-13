{ config, pkgs, ... }:
  {
    networking.hostName = "sima";

    # Use the systemd-boot efi boot loader.
    imports = [ ../../modules/systemd-boot.nix ];

    nix = {
      binaryCaches = [
        "http://kocka:5000"
      ];
      binaryCachePublicKeys = [
        "kocka:/M85ADJvkdibcMJtP+3uj4e3HCn/LkIAoy8r5V3QTNY="
      ];
    };

    hardware.bluetooth.enable = true;

    services.blueman.enable = true;

    services.xserver.synaptics = {
      enable = true;
      palmDetect = true;
      horizEdgeScroll = false;
      vertEdgeScroll = false;
      twoFingerScroll = true;
    };

    sound.extraConfig = ''
      defaults.pcm.!card 1
      defaults.ctl.!card 1
    '';

    # Allow mutable time zone for laptop
    time.timeZone = null;
    services.localtime.enable = true;
  }
