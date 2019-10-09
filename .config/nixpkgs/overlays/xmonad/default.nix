self: super: {
  xmonad-custom = self.haskellPackages.callPackage ./haskell-package/xmonad-custom.nix {};

  xmonad-session-init = (
    let desktopHack = { XDG_CURRENT_DESKTOP = "Unity"; };

        compose = f: g: x: f (g x);

        commands = [
          { pkg = self.haskellPackages.status-notifier-item; path = "/bin/status-notifier-watcher"; }
          { pkg = self.xorg.setxkbmap; path = "/bin/setxkbmap"; args = "-option compose:ralt"; }
          { pkg = self.dunst-custom; path = "/bin/dunst"; }
          { pkg = self.synapse; path = "/bin/synapse"; args = "-s"; }
          { pkg = self.compton; path = "/bin/compton"; }
          { pkg = self.networkmanagerapplet; path = "/bin/nm-applet"; args = "--indicator"; }
          { pkg = self.system-config-printer; path = "/bin/system-config-printer-applet"; }
          { pkg = self.powerlineWithGitStatus; path = "/bin/powerline-daemon"; args = "--replace"; }
          { pkg = self.udiskie; path = "/bin/udiskie"; args = "--tray --appindicator"; }
          { pkg = self.syncthing-gtk; path = "/bin/syncthing-gtk"; args = "--minimized"; }
          { pkg = self.lightlocker; path = "/bin/light-locker"; args = "--lock-on-suspend"; }
          { pkg = self.xmonad-custom; path = "/bin/launch-taffybar"; }
          { pkg = self.keepassxc; path = "/bin/keepassxc"; }
          { pkg = self.emacs-custom; path = "/bin/emacs"; args = "--bg-daemon"; }
          { pkg = self.slack; path = "/bin/slack"; vars = desktopHack; }
          { pkg = self.signal-desktop; path = "/bin/signal-desktop"; args = "--start-in-tray"; vars = desktopHack; }
        ];

        logDir = "$HOME/.local/var/log";
        mkEnvs = compose (super.lib.concatStringsSep " ") (super.lib.mapAttrsToList (k: v: k + "=" + v));
        bashify = { pkg, path, args ? "", vars ? {} }: (
          let envs = mkEnvs vars;
              logDir' = "${logDir}/${pkg.name}";
              cmd = "${envs} ${pkg}${path} ${args}  > ${logDir'}/stdout 2> ${logDir'}/stderr &!";
          in  ''
                echo >&2 "Running ${pkg.name}:   ${cmd}"
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
