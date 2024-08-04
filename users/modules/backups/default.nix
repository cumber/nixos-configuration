{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  inherit (pkgs) libsecret util-linux;

  host = osConfig.networking.hostName;
  user = config.home.username;

  mkBackupConfig = name: path: {
    location = {
      patterns =
        let
          stem = "home/${user}";
        in
        [
          "R /${stem}"
          "- ${stem}/Downloads"
          "- ${stem}/.cache"
          "- ${stem}/.config/chromium"
          "- ${stem}/.config/Slack"
          "- ${stem}/.config/discord"
          "- ${stem}/.config/Signal"
        ];

      repositories = [
        {
          label = "${name}";
          inherit path;
        }
      ];
    };

    storage = {
      encryptionPasscommand = ''
        ${libsecret}/bin/secret-tool lookup
          service borg-backup
          host ${host}
          user ${user}
          location vortalë
      '';

      extraConfig = {
        compression = "auto,zstd";
      };
    };

    retention = {
      keepHourly = 12;
      keepDaily = 15;
      keepMonthly = 12;
      keepYearly = -1;
    };

    consistency.checks = [
      {
        name = "repository";
        frequency = "2 weeks";
      }
      {
        name = "archives";
        frequency = "4 weeks";
      }
      {
        name = "data";
        frequency = "6 weeks";
      }
      {
        name = "extract";
        frequency = "3 months";
      }
    ];
  };
in
{
  services.borgmatic = {
    enable = true;
    frequency = "hourly";
  };

  # The service created by services.borgmatic sets the scheduling policy to
  # batch, which appears to be copied from borgmatic's suggested service file
  # that is intended to run as a system service, not a user service. Using batch
  # is *reducing* the process priority and ought to be allowed for unprivileged
  # user processes, but I get a permission error, which I don't understand. This
  # override makes it work for now.
  systemd.user.services.borgmatic.Service.CPUSchedulingPolicy = lib.mkForce "";

  programs.borgmatic = {
    enable = true;

    backups = {
      "vortalë" =
        let
          mount = "/run/media/${user}/vortalë";
        in
        mkBackupConfig "vortalë" "${mount}/${user}@${host}"
        // {
          hooks.extraConfig = {
            # exit 75 signals a soft failure to borgmatic, so it skips backup if
            # the drive isn't mounted
            before_actions = [ "${util-linux}/bin/findmnt ${mount} > /dev/null || exit 75" ];
          };
        };
    };
  };
}
