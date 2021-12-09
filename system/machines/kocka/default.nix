{ config, pkgs, ... }:
  {
    networking.hostName = "kocka";

    imports = [
      ../../modules/systemd-boot.nix
    ];

    # Need to allow for nix-serve to work
    networking.firewall.allowedTCPPorts = [ 5000 ];

    # Needed for use JACK apps
    users.extraUsers.cumber.extraGroups = [ "jackaudio" ];

    services = {
      fstrim.enable = true;

      sshd.enable = true;

      foldingathome = {
        enable = true;
        user = "cumber";
      };

      jack = {
        jackd.enable = true;
        jackd.extraOptions = [ "-dalsa" "-Phw:0" "-Chw:Adapter" ];
      };

      nix-serve = {
        enable = true;
        secretKeyFile = "/etc/nixos/secrets/nix-serve.sec";
      };

      # Use proprietary nvidia driver
      xserver = {
        videoDrivers = [ "nvidia" ];

        xrandrHeads = [
          {
            output = "DP-2";
            primary = true;
          }
          {
            output = "DP-4";
            monitorConfig = ''Option "Rotate" "left'';
          }
        ];
      };
    };

    virtualisation.docker.enable = true;

    # Set your time zone.
    time.timeZone = "Pacific/Auckland";
  }
