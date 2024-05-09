{ pkgs, lib, ... }:
let ulauncher = pkgs.ulauncher.overrideAttrs (old: {
      postPatch = ''
        substituteInPlace setup.py --subst-var out
        patchShebangs bin/ulauncher-toggle
        substituteInPlace bin/ulauncher-toggle \
          --replace-fail wmctrl ${pkgs.wmctrl}/bin/wmctrl
        ls
        substituteInPlace ulauncher.service \
          --replace-fail ExecStart=env ExecStart=/usr/bin/env \
          --replace-fail /usr/bin/ulauncher $out/bin/ulauncher
      '';
    });
in
{
  home.packages = [ ulauncher ];

  # Can't specify config using xdg.configFile, as ulauncher needs
  # writeable config files even if you don't actually change
  # anything. :(
  # Supposedly this will change when v6 is released
  home.activation = {
    initialiseUlauncherMutableConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p $HOME/.config/ulauncher
      for ulConf in settings.json extensions.json shortcuts.json; do
        if [[ ! -e $HOME/.config/ulauncher/$ulConf ]]; then
          run cp ${./config}/$ulConf $HOME/.config/ulauncher/$ulConf
          run chmod a=,u=rw $HOME/.config/ulauncher/$ulConf
        fi
      done
    '';
  };
}
