{ pkgs, ... }:
let
  inherit (pkgs) wlr-randr;
in
  {
    networking.hostName = "kocka";

    imports = [
      ../../modules/systemd-boot.nix
      ../../modules/pipewire.nix
      ../../modules/regreet.nix
      ../../modules/keyboard-rgb.nix
    ];

    # Use proprietary nvidia driver; even though this setting is named for
    # xserver it works for wayland
    services.xserver.videoDrivers = [ "nvidia" ];
    boot.kernelParams = [ "nvidia-drm.fbdev=1" ];

    # Wayland needs these to use nVidia GPU properly
    hardware.nvidia.modesetting.enable = true;
    environment.variables = {
      WLR_NO_HARDWARE_CURSORS = "1";
    };

    local.river.configForSystem = ''
      ${wlr-randr}/bin/wlr-randr --output DP-3 --transform 90
    '';

    # Need to allow for nix-serve to work
    networking.firewall.allowedTCPPorts = [ 5000 ];

    services = {
      fstrim.enable = true;

      sshd.enable = true;

      nix-serve = {
        enable = true;
        secretKeyFile = "/etc/nixos/secrets/nix-serve.sec";
      };
    };

    virtualisation.docker.enable = true;

    # Set your time zone.
    time.timeZone = "Australia/Melbourne";
  }
