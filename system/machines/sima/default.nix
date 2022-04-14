{ config, pkgs, ... }:
  {
    networking.hostName = "sima";

    imports = [
      ../../modules/systemd-boot.nix
      ../../modules/bluetooth.nix
      ../../modules/hidpi.nix
      ../../modules/touchpad.nix
    ];

    nix = {
      binaryCaches = [
        "http://kocka:5000"
      ];
      binaryCachePublicKeys = [
        "kocka:/M85ADJvkdibcMJtP+3uj4e3HCn/LkIAoy8r5V3QTNY="
      ];
    };

    services.xserver.monitorSection = ''
      DisplaySize  295 166
    '';

    sound.extraConfig = ''
      defaults.pcm.!card 1
      defaults.ctl.!card 1
    '';

    # Allow mutable time zone for laptop
    time.timeZone = null;
    services.localtime.enable = true;
  }
