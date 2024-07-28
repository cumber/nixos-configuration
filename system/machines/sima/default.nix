{ pkgs, ... }:
let
  inherit (pkgs) wlr-randr;
in
  {
    networking.hostName = "sima";

    imports = [
      ../../modules/systemd-boot.nix
      ../../modules/bluetooth.nix
      ../../modules/pipewire.nix
      ../../modules/regreet.nix
      ../../modules/touchpad.nix
      ../../modules/webcam-server.nix
    ];

    nix.settings = {
      substituters = [
        "http://kocka:5000"
      ];
      trusted-public-keys = [
        "kocka:/M85ADJvkdibcMJtP+3uj4e3HCn/LkIAoy8r5V3QTNY="
      ];
    };

    # Run at 1080 rather than 4K to save power and avoid annoying
    # hidpi configuration
    local.river.configForSystem = ''
      ${wlr-randr}/bin/wlr-randr --output eDP-1 --custom-mode 1920x1080
    '';

    # Allow mutable time zone for laptop
    time.timeZone = null;
    services.localtimed.enable = true;
  }
