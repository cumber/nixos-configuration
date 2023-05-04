self: super: {
  zdotdir = super.runCommand "zdotdir" {} ''
    mkdir -p $out/etc/zdotdir

    cp ${./zshenv} $out/etc/zdotdir/.zshenv

    substitute "${./zshrc}" "$out/etc/zdotdir/.zshrc" \
      --subst-var-by zsh-haskell "${self.zsh-haskell}" \
      --subst-var-by starship "${self.starship}" \
      --subst-var-by pandoc "${self.pandoc}"
  '';
}
