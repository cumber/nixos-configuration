{ config, pkgs, ... }:
  {
    networking.hostName = "vanwa";

    # Use the gummiboot efi boot loader.
    boot.loader.gummiboot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    services.xserver.synaptics.enable = true;
  }
