{ ... }:
# Provides XCompose rules for typing some symbols useful for maths and
# unicode-mode Haskell.

# TODO: Probably will want to introduce a proper option with merging
# if I want different modules with XCompose rules for different
# purposes.
{
  home.file.".XCompose".source = ./XCompose;
}
