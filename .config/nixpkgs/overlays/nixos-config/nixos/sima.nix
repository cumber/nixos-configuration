{ config, pkgs, ... }:
  {
    networking.hostName = "sima";

    # Use the systemd-boot efi boot loader.
    imports = [ ./systemd-boot.nix ];

    nix = {
      trustedBinaryCaches = [
        "http://kocka.goldie:5000"
        "https://cache.nixos.org/"
      ];
      binaryCachePublicKeys = [
        "kocka:/M85ADJvkdibcMJtP+3uj4e3HCn/LkIAoy8r5V3QTNY="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };

    hardware.bluetooth.enable = true;

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
  }
