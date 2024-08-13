{
  pkgs,
  config,
  lib,
  commands,
  ...
}:
let
  inherit (pkgs) graphite-gtk-theme graphite-cursors tela-icon-theme;
  inherit (commands) cage dbus wlr-randr;

  run-regreet = pkgs.writeShellScript "run-regreet" ''
    ${wlr-randr} \
      --output DP-2 --preferred \
      --output DP-3 --preferred --transform 90 --off
    exec ${lib.getExe config.programs.regreet.package}
  '';
in
{
  programs.regreet = {
    enable = true;

    settings = {
      GTK = {
        # Note; have to actually install themes system-wide, no way to point
        # direclty to theme packages from this config
        theme_name = "Graphite-Light-nord";
        icon_theme_name = "Tela-blue-light";
        cursor_theme_name = "graphite-light";
      };
    };
  };

  environment.systemPackages = [
    (graphite-gtk-theme.override { tweaks = [ "nord" ]; })
    (graphite-cursors)
    (tela-icon-theme)
  ];

  # Note: this is a single string, not shell syntax, so don't use a multiline
  # string with \ escaped newlines
  services.greetd.settings.default_session.command = toString [
    (dbus.getExe "dbus-run-session")
    cage
    (lib.escapeShellArgs config.programs.regreet.cageArgs)
    run-regreet
  ];
}
