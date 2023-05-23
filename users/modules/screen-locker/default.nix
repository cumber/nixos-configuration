{ pkgs, ... }:
{
  services.screen-locker = {
    enable = true;

    lockCmd = "${pkgs.i3lock}/bin/i3lock --nofork --color=000000 --pointer=default --show-failed-attempts";
    xss-lock.extraOptions = [ "--transfer-sleep-lock" ];
  };
}
