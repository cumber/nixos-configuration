# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # see https://nixos.wiki/wiki/Scanners#Network_scanning
    ./sane-extra-config.nix

    # Extra substituters
    ./reflex-frp.nix
    ./haskell-nix.nix
    ./cachix.nix
  ];

  nix.settings = {
    auto-optimise-store = true;
    keep-outputs = true;
    experimental-features = [
      "nix-command"
      "flakes"
      "repl-flake"
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
      # Needed to allow autodetection of network printer via BJNP
      8611

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
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.cumber = import ../../users/cumber;
  };

  services = {
    avahi = {
      enable = true;
      nssmdns = true;
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
      locate = pkgs.plocate;
      localuser = null;
      interval = "hourly";
    };

    printing = {
      enable = true;
      drivers = [ pkgs.cups-bjnp pkgs.gutenprint ];
    };

    upower.enable = true;

    xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
        session = [
          {
            name = "home-manager";
            start = ''
              $HOME/.hm-xsession &
              waitPID=$!
            '';
          }
        ];
      };

      displayManager = {
        lightdm.enable = true;
        lightdm.greeters.enso.enable = true;
        lightdm.greeters.gtk.enable = false;
        defaultSession = "home-manager";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    dconf
    gnome2.GConf
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

  # With this enabled, we were trying to load a kernel module snd_pcm_oss that
  # isn't actually installed.
  sound.enableOSSEmulation = false;

  hardware.sane = {
    enable = true;
    extraConfig = {
      "pixma" = "bjnp://192.168.1.229";
    };
  };

  # Use GTK portals, since most of my apps are GTK even though I'm not
  # using Gnome.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
}
