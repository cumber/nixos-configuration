# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # see https://nixos.wiki/wiki/Scanners#Network_scanning
    ./sane-extra-config.nix

    # Extra substituters
    ./reflex-frp.nix
    ./haskell-nix.nix
    ./cachix.nix

    ./river
  ];

  nix.settings = {
    auto-optimise-store = true;
    keep-outputs = true;
    experimental-features = [
      "nix-command"
      "flakes"
      "ca-derivations"
    ];
  };

  # boot.loader is expected to be defined in machine-specific module

  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=1
  '';

  boot.tmp.useTmpfs = true;

  # hostName is expected to be defined in machine-specific module;
  networking = {
    networkmanager = {
      enable = true;
    };

    # Used by Syncthing for syncing
    firewall.allowedTCPPorts = [ 22000 ];

    firewall.allowedUDPPorts = [
      # Used by Syncthing for syncing & discovery
      21027
      22000
    ];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";

    # Needed for now to make font selection work properly
    earlySetup = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.cumber = import ../../users/cumber;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
      };
    };

    # Needed for file-manager applications to support trash, etc
    gvfs.enable = true;

    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "hourly";
    };

    printing = {
      enable = true;
      drivers = [ pkgs.gutenprint ];
    };

    upower.enable = true;
  };

  environment.systemPackages = with pkgs; [
    dconf
    shared-mime-info
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
        hashedPasswordFile = "/etc/nixos/secrets/root.pass";
      };

      cumber = {
        isNormalUser = true;
        description = "Cumber";
        hashedPasswordFile = "/etc/nixos/secrets/cumber.pass";
        extraGroups =  [ "wheel" "networkmanager" "scanner" ];
      };

      drop = {
        isSystemUser = true;
        description = "A user with minimal permissions, used for privilage dropping";
        group = "drop";
      };
    };

    groups = {
      drop = {};
      kvm = {};
      render = {};
    };
  };

  security.sudo.extraRules = [
    {
      groups = [ "users" ];
      runAs = "drop";
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  hardware.sane = {
    enable = true;
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
}
