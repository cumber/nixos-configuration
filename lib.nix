{ lib }:
lib // rec {
  compose = f: g: x: f (g x);
  composeAll = lib.foldr compose lib.id;

  readSubDirs = composeAll [
    lib.attrNames
    (lib.filterAttrs (_: type: type == "directory"))
    builtins.readDir
  ];
}
