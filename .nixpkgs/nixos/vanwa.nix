{ config, pkgs, ... }:
  {
    networking.hostName = "vanwa";

    # Use the systemd-boot efi boot loader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    services.xserver.synaptics.enable = true;
  }
