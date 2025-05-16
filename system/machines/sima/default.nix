{ commands, ... }:
let
  inherit (commands) wlr-randr;
in
{
  networking.hostName = "sima";

  imports = [
    ../../modules/bluetooth.nix
    ../../modules/disk
    ../../modules/localtimed
    ../../modules/pipewire.nix
    ../../modules/regreet.nix
    ../../modules/sshd
    ../../modules/systemd-boot.nix
    ../../modules/touchpad.nix
    ../../modules/webcam-server.nix
  ];

  nix.settings = {
    substituters = [ "ssh-ng://nix-ssh@kocka" ];
    trusted-public-keys = [ "kocka-1:7vlCSOFsUsip5vdrIcrmCR21Wh+st2tl3IXHsFXaV+o=" ];
  };

  # Run at 1080 rather than 4K to save power and avoid annoying
  # hidpi configuration
  local.river.configForSystem = ''
    ${wlr-randr} --output eDP-1 --custom-mode 1920x1080
  '';

  powerManagement.cpuFreqGovernor = "powersave";
}
