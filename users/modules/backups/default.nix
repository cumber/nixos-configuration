{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}:
let
  inherit (pkgs)
    libsecret
    networkmanager
    util-linux
    writeShellApplication
    ;

  host = osConfig.networking.hostName;
  user = config.home.username;

  mkBackupConfig = name: path: {
    location = {
      patterns =
        let
          stem = "home/${user}";
        in
        [
          "R /${stem}/./"
          "- ${stem}/Downloads/"
          "- ${stem}/.cache"
          "- ${stem}/.snapshots"
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
          location ${name}
      '';

      extraConfig = {
        # More readable and easy to type archive names; one per minute is enough
        archive_name_format = "{now:%Y-%m-%d_%H:%M}";

        compression = "auto,zstd";
      };
    };

    retention = {
      keepHourly = 48;
      keepDaily = 15;
      keepMonthly = 12;
      keepYearly = -1;
    };

    # NOTE: data and extract checks are impractical to run automatically for
    # remote backups; I should manually run them occaisionally
    consistency.checks = [
      {
        name = "repository";
        frequency = "1 month";
      }
      {
        name = "archives";
        frequency = "1 month";
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
      "vortalë" = (
        let
          mount = "/run/media/${user}/vortalë";
        in
        lib.mkMerge [
          (mkBackupConfig "vortalë" "${mount}/${user}@${host}")
          {
            hooks.extraConfig = {
              commands = [
                {
                  # exit 75 signals a soft failure to borgmatic, so it skips backup if
                  # the drive isn't mounted
                  run = [ "${util-linux}/bin/findmnt ${mount} > /dev/null || exit 75" ];
                  before = "repository";
                }
              ];
            };

            # data and extract checks are fast enough to run automatically here
            consistency.checks = [
              {
                name = "data";
                frequency = "1 month";
              }
              {
                name = "extract";
                frequency = "3 months";
              }
            ];
          }
        ]
      );

      borgbase = (
        let
          host-repos = {
            kocka = "ssh://h3jgy72p@h3jgy72p.repo.borgbase.com/./repo";
            sima = "ssh://ebd6bocz@ebd6bocz.repo.borgbase.com/./repo";
          };

          check-wifi = writeShellApplication {
            name = "check-wifi";
            runtimeInputs = [ networkmanager ];
            text = ''
              # exit 75 signals a soft failure to borgmatic, so it skips backup
              # if we're not connected to specific wifi network
              if [[ "$(nmcli --terse --fields GENERAL.STATE connection show Möbius)" == "GENERAL.STATE:activated" ]]; then
                exit 0
              else
                exit 75
              fi
            '';
          };
        in
        lib.mkMerge [
          (mkBackupConfig "borgbase" host-repos.${host})
          (lib.mkIf (host == "sima") {
            hooks.extraConfig.before_actions = [ "${lib.getExe check-wifi}" ];
          })
          {
            location.extraConfig = {
              # Allow marking specific folders to be left out of remote backups
              # by including a file with this name. There are some large but
              # low-value stuff I'm okay with only being backed up locally.
              exclude_if_present = [ "EXCLUDE-FROM-REMOTE-BACKUP" ];
              keep_exclude_tags = true;
            };
          }
        ]
      );
    };
  };
}
