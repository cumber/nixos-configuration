self: super: {
  xmonad-custom = self.haskellPackages.callPackage ./haskell-package/xmonad-custom.nix {};

  xmonad-session-init = (
    let desktopHack = { XDG_CURRENT_DESKTOP = "Unity"; };

        compose = f: g: x: f (g x);

        commands = [
          { pkg = self.haskellPackages.status-notifier-item; path = "/bin/status-notifier-watcher"; }
          { pkg = self.xorg.setxkbmap; path = "/bin/setxkbmap"; args = "-option compose:ralt"; }
          { pkg = self.dunst-custom; path = "/bin/dunst"; }
          { pkg = self.albert; path = "/bin/albert"; }
          { pkg = self.picom; path = "/bin/picom"; }
          { pkg = self.networkmanagerapplet; path = "/bin/nm-applet"; args = "--indicator"; }
          { pkg = self.system-config-printer; path = "/bin/system-config-printer-applet"; }
          { pkg = self.udiskie; path = "/bin/udiskie"; args = "--tray --appindicator"; }
          { pkg = self.syncthing-gtk; path = "/bin/syncthing-gtk"; args = "--minimized"; }
          { pkg = self.lightlocker; path = "/bin/light-locker"; args = "--lock-on-suspend --late-locking"; }
          { pkg = self.xmonad-custom; path = "/bin/launch-taffybar"; logName = "taffybar"; }
          { pkg = self.keepassxc; path = "/bin/keepassxc"; }
          { pkg = self.emacs-custom; path = "/bin/emacs"; args = "--bg-daemon"; logName = "emacs-daemon"; }
          { pkg = self.signal-desktop; path = "/bin/signal-desktop"; args = "--start-in-tray"; vars = desktopHack; }
        ];

        logDir = "$HOME/.local/var/log";
        mkEnvs = compose (super.lib.concatStringsSep " ") (super.lib.mapAttrsToList (k: v: k + "=" + v));
        bashify = { pkg, path, args ? "", logName ? (builtins.parseDrvName pkg.name).name, vars ? {} }: (
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
