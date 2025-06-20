{ commands, ... }:
let
  inherit (commands) wlr-randr;
in
  {
    networking.hostName = "kocka";

    imports = [
      ../../modules/disk
      ../../modules/sshd
      ../../modules/systemd-boot.nix
      ../../modules/pipewire.nix
      ../../modules/regreet.nix
      ../../modules/keyboard-rgb.nix
      ../../modules/serve-nix-store.nix
    ];

    services.xserver.videoDrivers = [ "nvidia" ];

    local.river.configForSystem = ''
      ${wlr-randr} --output DP-3 --transform 90
    '';

    powerManagement.cpuFreqGovernor = "ondemand";

    virtualisation.docker.enable = true;

    # Set your time zone.
    time.timeZone = "Australia/Melbourne";
  }
