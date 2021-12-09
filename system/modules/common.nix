# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./bluetooth.nix

    # see https://nixos.wiki/wiki/Scanners#Network_scanning
    ./sane-extra-config.nix

    ./reflex-frp.nix

    ./haskell-nix.nix
  ];

  nix.package = pkgs.nixFlakes;

  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  # boot.loader is expected to be defined in machine-specific module

  boot.extraModprobeConfig = ''
    options snd_hda_intel enable=1
  '';

  boot.tmpOnTmpfs = true;

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

    dnsmasq = {
      enable = true;
      extraConfig = ''
        address=/localhost.com/127.0.0.1
      '';
    };

    locate.enable = true;

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
    gnome3.dconf
    gnome2.GConf
    shared_mime_info
  ];

  programs = {
    ssh = {
      startAgent = true;
      agentTimeout = "1h";
    };

    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting = {
        enable = true;
        highlighters = [ "main" "brackets" ];
      };

      shellInit = ''export ZDOTDIR="${pkgs.zdotdir}/etc/zdotdir"'';
    };
  };

  users = {
    mutableUsers = false;

    users = {
      root = {
        passwordFile = "/etc/nixos/secrets/root.pass";
      };

      cumber = {
        isNormalUser = true;
        description = "Cumber";
        passwordFile = "/etc/nixos/secrets/cumber.pass";
        extraGroups =  [ "wheel" "networkmanager" "scanner" ];
        shell = pkgs.zsh;
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

  # With this enabled, we were trying to load a kernel module snd_pcm_oss that
  # isn't actually installed.
  sound.enableOSSEmulation = false;

  hardware.pulseaudio = {
    enable = true;
  };

  hardware.sane = {
    enable = true;
    extraConfig = {
      "pixma" = "bjnp://192.168.1.229";
    };
  };

  # Thunderbird crashes with portals enabled; will be fixed in v68
  xdg.portal.enable = false;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "18.03";
}
