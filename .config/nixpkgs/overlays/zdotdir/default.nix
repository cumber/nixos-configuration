self: super: {
  zdotdir = super.runCommand "zdotdir" {} ''
    mkdir -p $out/etc/zdotdir
    cp ${./zshenv} $out/etc/zdotdir/.zshenv
    echo "source ${self.gnome3.vte}/etc/profile.d/vte.sh" \
      | cat ${./zshrc} - > $out/etc/zdotdir/.zshrc
    echo 'eval "$(${self.starship}/bin/starship init zsh)"' \
      >> $out/etc/zdotdir/.zshrc
  '';
}
