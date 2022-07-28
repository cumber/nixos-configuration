{ config, pkgs, ... }:
  {
    networking.hostName = "sima";

    imports = [
      ../../modules/systemd-boot.nix
      ../../modules/bluetooth.nix
      ../../modules/pipewire.nix
      ../../modules/touchpad.nix
    ];

    nix.settings = {
      trusted-substituters = [
        "http://kocka:5000"
      ];
      trusted-public-keys = [
        "kocka:/M85ADJvkdibcMJtP+3uj4e3HCn/LkIAoy8r5V3QTNY="
      ];
    };

    # Run at 1080 rather than 4K to save power and avoid annoying
    # hidpi configuration
    services.xserver.resolutions = [
      { x = 1920; y = 1080; }
    ];

    sound.extraConfig = ''
      defaults.pcm.!card 1
      defaults.ctl.!card 1
    '';

    # Allow mutable time zone for laptop
    time.timeZone = null;
    services.localtimed.enable = true;
  }
