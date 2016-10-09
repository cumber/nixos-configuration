# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      (throw "replace this throw with machine-specific module")
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

  # List services that you want to enable:
  services.locate.enable = true;

  services.printing.enable = true;

  services.upower.enable = true;

  services.xserver = {
    enable = true;

    displayManager.lightdm.enable = true;

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = haskellPackages : [ haskellPackages.taffybar ];
    };
  };

  environment.systemPackages = [ pkgs.shared_mime_info ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };
  users.mutableUsers = false;
  users.users.root = {
    passwordFile = "/etc/nixos/passwords/root";
  };
  users.users.cumber = {
    isNormalUser = true;
    description = "Cumber";
    passwordFile = "/etc/nixos/passwords/cumber";
    extraGroups =  [ "wheel" "networkmanager" ];
    shell = "/home/cumber/.nix-profile/bin/zsh";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
