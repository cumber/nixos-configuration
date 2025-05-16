{ ... }:
{
  nix.sshServe = {
    enable = true;
    protocol = "ssh-ng";
    keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhD7T9eshOSWHk7E4jMtPolSr5/rbExVtTwJ/AQytWd root@sima" ];
  };

  nix.extraOptions = ''
    secret-key-files = /etc/nixos/secrets/nix-secret-key
  '';
}
