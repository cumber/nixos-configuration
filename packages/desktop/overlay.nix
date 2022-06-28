self: super: {
  xmonad-custom = self.haskellPackages.callPackage ./xmonad-custom/xmonad-custom.nix { sys-pulseaudio = self.pulseaudio; };

  # Turn off unneeded KIO and plasmoid support in syncthing.
  # Also override the web view engine to be Qt WebKit instead of
  # Qt WebEngine. Supposedly it has fewer limitations, and at one point
  # it failed to build against WebEngine in nixpkgs.
  syncthingtray = (super.syncthingtray.override {
    webviewSupport = false;
    kioPluginSupport = false;
    plasmoidSupport = false;
  }).overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [ "-DWEBVIEW_PROVIDER:STRING=webkit" ];
    buildInputs = old.buildInputs ++ [ self.qt5.qtwebkit ];
  });

  syncthing-delay-start = super.writeScriptBin "syncthingtray" ''
    sleep 5
    ${self.syncthingtray}/bin/syncthingtray "$@"
  '';

  xmonad-session-init = (
    let compose = f: g: x: f (g x);

        commands = [
          { pkg = self.haskellPackages.status-notifier-item; path = "/bin/status-notifier-watcher"; }
          { pkg = self.xorg.setxkbmap; args = "-option compose:ralt"; }
          { pkg = self.dunst-custom; }
          { pkg = self.albert; }
          { pkg = self.picom; }
          { pkg = self.system-config-printer; path = "/bin/system-config-printer-applet"; }
          { pkg = self.udiskie; path = "/bin/udiskie"; args = "--tray --appindicator"; }
          { pkg = self.syncthing-delay-start; }
          { pkg = self.lightlocker; args = "--lock-on-suspend --late-locking"; }
          { pkg = self.keepassxc; }
          { pkg = self.emacs-custom; path = "/bin/emacs"; args = "--bg-daemon"; logName = "emacs-daemon"; }
          { pkg = self.signal-desktop; args = "--start-in-tray"; }
          { pkg = self.gwe; args = "--hide-window"; }
        ];

        logDir = "$HOME/.local/var/log";
        mkEnvs = compose (super.lib.concatStringsSep " ") (super.lib.mapAttrsToList (k: v: k + "=" + v));
        bashify = { pkg, path ? "/bin/${name}", args ? "", logName ? name, name ? (builtins.parseDrvName pkg.name).name, vars ? {} }: (
          let envs = mkEnvs vars;
              logDir' = "${logDir}/${logName}";
              cmd = "${envs} ${pkg}${path} ${args}  > ${logDir'}/stdout 2> ${logDir'}/stderr &!";
          in  ''
                echo >&2 "Running ${logName}:   ${cmd}"
                mkdir -p ${logDir'}
                ${cmd}
              ''
        );

    in  super.writeScriptBin "xmonad-session-init" (
          super.lib.concatStringsSep "\n\n" (
            ["#!${self.stdenv.shell}" "mkdir -p ${logDir}" "exec 2> ${logDir}/session-init-log"]
            ++ (map bashify commands)
          )
        )
  );
}
