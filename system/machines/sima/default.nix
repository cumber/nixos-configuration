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

  #nix.settings = {
  #  substituters = [ "http://kocka:5000" ];
  #  trusted-public-keys = [ "kocka:/M85ADJvkdibcMJtP+3uj4e3HCn/LkIAoy8r5V3QTNY=" ];
  #};

  # Run at 1080 rather than 4K to save power and avoid annoying
  # hidpi configuration
  local.river.configForSystem = ''
    ${wlr-randr} --output eDP-1 --custom-mode 1920x1080
  '';

  powerManagement.cpuFreqGovernor = "powersave";
}
