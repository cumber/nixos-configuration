{ config, pkgs, ... }:
  {
    networking.hostName = "vanwa";

    # Use the systemd-boot efi boot loader.
    imports = [ ./systemd-boot.nix ];

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
