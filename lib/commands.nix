/**
  This module is intended to reduce the boilerplate of explicitly "importing"
  packages to be used in commands in module configuration, so there is an
  easy record of what packages a module depends on near the top of the file.

  It injects an argument `commands` into every module, which mirrors the
  structure of pkgs but wraps every derivation into a set exposing:
    - pkg: the original derivation as
    - exe: the main executable of the package (as lib.getExe)
    - getExe: a function for getting a specific named executable from the
      package (as lib.getExe')
    - a __toString function returning `exe`, so the set can be directly used
      in string splices

  This allows module style such as this:

  ```
  { pkgs, commands, ... }:
  let
    inherit (commands) hello;
  in
  {
    environment.systemPackages = [
      hello.pkg
      (pkgs.writeShellScript "example.sh" ''
        echo "Calling hello"
        ${hello}
      '')
    ];
  }

  `commands` also contains a function `from`, allows a package set to be passed
  in instead of wrapping `pkgs`, but also requires that the attribute names in
  the package set correspond to the executable names. This allows an alternative
  syntax for "importing" specific commands from multi-command packages (or
  specifying the exectuable name where the package doesn't have a `mainProgram`
  set). For example:

  { pkgs, commands, ... }:
  with (commands.from { sleep = pkgs.coreutils; });
  {
    environment.systemPackages = [
      (pkgs.writeShellScript "wait-a-bit" ''
        ${sleep} 5s
      '')
    ];
  }

  Here using `with` avoids repeating the name `sleep` more than once in the
  "import" section, and should be clear to a human reader that only the name
  `sleep` is brought into scope (although not to static analysis tools).
  ```
*/
{ lib, pkgs, ... }:
let
  commands-from =
    use-name:
    lib.mapAttrsRecursiveCond (p: !(lib.isDerivation p)) (
      attr-path: pkg: {
        __toString = self: self.exe;
        inherit pkg;
        exe = if use-name then lib.getExe' pkg (lib.last attr-path) else lib.getExe pkg;
        getExe = lib.getExe' pkg;
      }
    );
in
{
  _module.args = {
    commands = commands-from false pkgs // {
      from = commands-from true;
    };
  };
}
