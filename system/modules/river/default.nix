{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (pkgs)
    river

    writeTextFile
    writeShellScript
    ;

  # Provide our own desktop session file for river, so we can wrap river with
  # some environment variables
  river-desktop = writeTextFile {
    name = "river.desktop";
    executable = true;
    text = ''
      [Desktop Entry]
      Name=River
      Comment=A dynamic tiling Wayland compositor
      Exec=${run-river} 
      Type=Application
    '';
  };

  # Wrapper that sets variables before starting river, including Home Manager
  # session variables (if the file exists). These variables will be set in
  # the main river process, and thus propagated to all child processes in
  # the session.
  run-river = writeShellScript "run-river" ''
    export XDG_CURRENT_DESKTOP=river
    export NIXOS_OZONE_WL=1

    hmSessionVars="/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
    if [[ -f "$hmSessionVars" ]]; then
      source $hmSessionVars
    fi

    exec "${river}/bin/river" -c "${river-pre-init}"
  '';

  # We use our own init instead of letting river find one, so we can apply
  # local.river.configForSystem settings, then exec river's normal init (which
  # would usually be configured per-user in Home Manager).
  #
  # Any variables exported here will be propagated to the normal init process,
  # but applications run in the session are not children of that init so they
  # will not see these variables (though they would be available to the
  # dbus-update-activation-environment call that Home Manager generates).
  river-pre-init = writeShellScript "river-pre-init" ''
    ${config.local.river.configForSystem}

    init="''${XDG_CONFIG_HOME:-$HOME/.config}/river/init"
    if [[ -e "$init" ]]; then
      exec "$init"
    fi
  '';
in
{
  options = {
    local.river.configForSystem = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Additional commands for configuring a river session that are specific to
        the system, rather than to a user. Will run before the init configured
        in Home Manager.
      '';
    };
  };

  config = {
    programs.river = {
      enable = true;

      # Seeing how far I can get without xwayland
      xwayland.enable = false;

      package = river.overrideAttrs (old: {
        postInstall = ''
          install "${river-desktop}" -D "$out/share/wayland-sessions/river.desktop"
        '';
      });
    };
  };
}
