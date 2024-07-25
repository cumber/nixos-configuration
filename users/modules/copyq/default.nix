{ lib, ... }:
{
  services.copyq = {
    enable = true;
  };

  # Override QT_QPA_PLATFORM=xcb setting that would force it to use xwayland
  systemd.user.services.copyq.Service.Environment = lib.mkForce [];
}
