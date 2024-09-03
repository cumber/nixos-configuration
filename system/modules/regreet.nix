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
      --output DP-1 --preferred \
      --output DP-2 --off
    exec ${lib.getExe config.programs.regreet.package}
  '';
in
{
  programs.regreet = {
    enable = true;

    theme = {
      name = "Graphite-Light-nord";
      package = graphite-gtk-theme.override { tweaks = [ "nord" ]; };
    };
    cursorTheme = {
      name = "graphite-light";
      package = graphite-cursors;
    };
    iconTheme = {
      name = "Tela-blue-light";
      package = tela-icon-theme;
    };
  };

  # Note: this is a single string, not shell syntax, so don't use a multiline
  # string with \ escaped newlines
  services.greetd.settings.default_session.command = toString [
    (dbus.getExe "dbus-run-session")
    cage
    (lib.escapeShellArgs config.programs.regreet.cageArgs)
    run-regreet
  ];
}
