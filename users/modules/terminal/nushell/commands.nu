# Starts nushell inside a `nix shell`, using nix-output-monitor
def --wrapped ns [
   ...rest # All arguments will be passed to nix shell
] {
  nom shell ...$rest -c nu
}

# Starts nushell inside `nix develop --impure`, using nix-output-monitor
def --wrapped nd [
  ...rest # All arguments will be passed to nix develop
] {
  nom develop --impure ...$rest -c nu
}

# Runs `devenv up` inside `nix develop --impure`
def --wrapped "nd up" [
  ...rest # All arguments will be passed to nix develop
] {
  nix develop --impure ...$rest -c devenv up
}

# Runs `nix repl` preloaded with the <repl> path; my system
# config defines this with a helpful set of variables (all of
# nixpkgs, builtins and lib more easily available, etc).
def --wrapped nr [
  ...rest # All arguments will be passed to nix repl
] {
  nix repl --file <repl> ...$rest
}
