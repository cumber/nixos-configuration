{ config, pkgs, ... }:
  {
    networking.hostName = "kocka";

    # Use the systemd-boot efi boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    nix = {
      binaryCaches = [
        "https://cache.nixos.org/"
      ];
      binaryCachePublicKeys = [
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
