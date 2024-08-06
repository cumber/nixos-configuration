{ lib, pkgs, ... }:
let
  waylock = lib.getExe pkgs.waylock;
in
{
  home.packages = [
    pkgs.waylock # NOTE: needs system-level PAM config to be able to unlock!
  ];

  # Note: this relies on systemd-lock-handler being installed at system level
  systemd.user.services.waylock = {
    Unit = {
      Description = "Lock screen with waylock on logind lock events";
      OnSuccess = "unlock.target";
      PartOf = "lock.target";
      After = "lock.target";
    };

    Service = {
      Type = "forking";
      ExecStart = "${waylock} -fork-on-lock -ignore-empty-password";
      Restart = "on-failure";
      RestartSec = 0;
    };

    Install = {
      WantedBy = [ "lock.target" ];
    };
  };
}
