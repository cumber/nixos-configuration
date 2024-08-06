# NOTE: This module does not actually install or configure waylock. Rather it
# provides system-level settings that are necessary for waylock to be set up
# at user-level.
{ pkgs, ... }:
let
  inherit (pkgs) waylock;
in
{
  # Need to install this service in order to translate logind events into
  # activations of the user-level lock.target
  services.systemd-lock-handler.enable = true;

  # Even though we're not installing waylock system-wide, we need to put its PAM
  # module in the system so it is allowed to authenticate users to unlock
  security.pam.services.waylock.text = builtins.readFile (waylock + /etc/pam.d/waylock);
}
