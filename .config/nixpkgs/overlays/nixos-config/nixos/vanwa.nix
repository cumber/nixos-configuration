{ config, pkgs, ... }:
  {
    networking.hostName = "vanwa";

    # Use the systemd-boot efi boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix = {
      binaryCaches = [
        # "http://alyamar.goldie:5000"
        "https://cache.nixos.org/"
      ];
      binaryCachePublicKeys = [
        # "alyamar:6Gg2JIhXz/NTUI77hdIlTkNlArdF9yvz3dqNRhpjXuo="
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