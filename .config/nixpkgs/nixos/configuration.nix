# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      (throw "replace this throw with machine-specific module")

      ./reflex-frp.nix
    ];

  nix.extraOptions = ''
    auto-optimise-store = true
  '';

  # boot.loader is expected to be defined in machine-specific module

  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=1
  '';

  # hostName is expected to be defined in machine-specific module;
  networking = {
    extraHosts = "127.0.0.1 ${config.networking.hostName}";
    networkmanager.enable = true;
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_AU.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Australia/Melbourne";

  services = {
    locate.enable = true;

    printing.enable = true;

    upower.enable = true;

    xserver = {
      enable = true;

      displayManager.lightdm.enable = true;
      displayManager.session = [
        {
          manage = "window";
          name = "xmonad-custom";
          start = ''
            export GIO_EXTRA_MODULES="/run/current-system/sw/lib/gio/modules"
            xmonad-custom &
            waitPID=$!
          '';
        }
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    gnome3.dconf
    gnome3.gconf
    gnome3.nautilus
    shared_mime_info
  ];

  programs = {
    ssh = {
      startAgent = true;
      agentTimeout = "1h";
    };
  };

  users = {
    mutableUsers = false;

    users = {
      root = {
        passwordFile = "/etc/nixos/passwords/root";
      };

      cumber = {
        isNormalUser = true;
        description = "Cumber";
        passwordFile = "/etc/nixos/passwords/cumber";
        extraGroups =  [ "wheel" "networkmanager" ];
        shell = "/home/cumber/.nix-profile/bin/zsh";
      };
    };
  };

  environment.shells = [
    "/home/cumber/.nix-profile/bin/zsh"
  ];

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.09";

}
