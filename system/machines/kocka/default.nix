{ config, pkgs, ... }:
  {
    networking.hostName = "kocka";

    imports = [
      ../../modules/systemd-boot.nix
      ../../modules/pipewire.nix
    ];

    # Need to allow for nix-serve to work
    networking.firewall.allowedTCPPorts = [ 5000 ];

    services = {
      fstrim.enable = true;

      sshd.enable = true;

      foldingathome = {
        enable = true;
        user = "cumber";
      };

      nix-serve = {
        enable = true;
        secretKeyFile = "/etc/nixos/secrets/nix-serve.sec";
      };

      # By default pipewire assigns higher priority to the headphone
      # playback port on the webcam than to my speakers. :(
      pipewire = {
        media-session.config.alsa-monitor = {
          rules = [
            {
              actions = {
                update-props = {
                  "priority.driver" = 100;
                  "priority.session" = 100;
                };
              };
              matches = [
                {
                  "node.nick" = "WebMic HD Pro";
                  "media.class" = "Audio/Sink";
                }
              ];
            }
          ];
        };
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
    time.timeZone = "Australia/Melbourne";
  }
