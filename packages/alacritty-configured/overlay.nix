self: super: {
  alacritty-configured = super.symlinkJoin {
    inherit (self.alacritty) name;
    paths = [ self.alacritty ];
    buildInputs = [ self.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/alacritty \
        --add-flags "--no-live-config-reload --config-file=${./alacritty.yml}"
    '';
  };
}
